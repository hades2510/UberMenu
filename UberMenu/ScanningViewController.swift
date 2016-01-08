//
//  ViewController.swift
//  UberMenu
//
//  Created by Mac on 13/11/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class ScanningViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var bleManager: CBCentralManager!;
    var peripheral: CBPeripheral!;
    var rawMenu   : String="";
    
    var menuLength: Int32 = 0;
    var menuReadBytes: Int32 = 0;

    var currentState:UBWelcomeState = .InitialState
    
    private var menuName:String = ""

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var debugView: UITextView!
    @IBOutlet weak var connectionIndTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectionIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    
    func log(what:String)
    {
        debugView.text = debugView.text + what + "\n";
        print(what)
    }
    
    func logInt(what:Int)
    {
        log(String(what));
    }
    
    //MARK - CBCentralManagerDelegate
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if( central.state == .PoweredOn )
        {
            self.startScan();
        }
        else{
            self.changeState(.BLTurnedOff)
        }
        
        logInt(central.state.rawValue);
    }
    
    func centralManager(central: CBCentralManager,
        didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String : AnyObject],
        RSSI: NSNumber)
    {
        log("Scan found result")
        if let data = advertisementData[CBAdvertisementDataManufacturerDataKey]
        {
            let finalData:NSData = data.subdataWithRange(NSRange(location: 2,length: data.length-3))
        
            if let name = String(data:finalData, encoding:NSUTF8StringEncoding)
            {
                log("Received name:")
                log(name)
                
                self.menuName = name
                
                self.changeState(.MenuFound)
                
                self.peripheral = peripheral
                self.peripheral.delegate = self
                
                log("Connecting to peripheral")
                central.connectPeripheral(self.peripheral, options: nil)
            }
        }
        else{
            log("no data for the current service")
        }
        
        //central.stopScan()
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        log("Discover services")
        peripheral.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        log("Discover characteristics")
        peripheral.discoverCharacteristics(nil, forService: peripheral.services![0])
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        log("Registering for notifications")
        peripheral.setNotifyValue(true, forCharacteristic: service.characteristics![0])
        log("Reading menu/characteristic")
        self.changeState(.ReadingMenu)
        readMenu()
        stopScanning();
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil{
            log(error.debugDescription)
            return
        }
        
        log( characteristic.debugDescription )
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil
        {
            log("error: "+error.debugDescription)
            return
        }
        
        if let data = characteristic.value
        {
            log("got characteristic update")
            
            let pointer = UnsafePointer<Int8>(data.bytes)
            
            log(String(CString: pointer, encoding: NSASCIIStringEncoding )!)
            
            //get the length of the menu
            if self.menuLength == 0
            {
                data.getBytes(&self.menuLength,length:sizeof(Int32))
                log("Menu length is \(menuLength)")
            }
            else
            {
                let currentString = String(CString: pointer, encoding: NSASCIIStringEncoding )!
                
                self.menuReadBytes += data.length
            
                rawMenu += currentString;
                
                if menuReadBytes >= self.menuLength{
                    
                    UBContext.sharedInstance.menu = Menu(rawMenu)
                    UBContext.sharedInstance.menu.name = self.menuName
                        
                    self.changeState(.MenuReceived)
                    presentMenu()
                }
            }
        }
    }
    
    func readMenu()
    {
        if let service:CBService = peripheral.services![0]
        {
            if let characteristic:CBCharacteristic = service.characteristics![0]
            {
                if let data =  characteristic.value
                {
                    let pointer = UnsafePointer<Int8>(data.bytes)
                    log("Got menu")
                    log("menu length")
                    logInt(data.length)
                    log("menu")
                    
                    log(String(CString: pointer, encoding: NSASCIIStringEncoding )!)
                    
                    //menuArea.text = String(CString: pointer, encoding: NSASCIIStringEncoding )
                }
            }
        }
    }
    
    func startScan()
    {
        log("Starting scan")
        self.changeState(.StartedSearch)
        bleManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func stopScanning(){
        bleManager.stopScan()
    }
    
    func presentMenu(){
        
    }
    
    func changeState(state:UBWelcomeState){
        currentState = state
        self.statusLabel.text = state.description
        
        switch state{
        case .InitialState:
            self.connectionIndicator.startAnimating()
            self.menuButton.alpha = 0.0
        case .BLTurnedOff:
            self.connectionIndicator.stopAnimating()
        case .StartedSearch:
            self.connectionIndicator.startAnimating()
        case .MenuReceived:
            self.connectionIndicator.stopAnimating()
            
            //self.view.layoutIfNeeded()
            self.menuButton.setTitle( self.menuName, forState: .Normal)

            UIView.animateWithDuration(1.0, animations: {
                self.connectionIndicator.alpha = 0.0
                self.menuButton.alpha = 1.0
                self.connectionIndTopConstraint.constant = -16
                self.view.layoutIfNeeded()
                })
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.changeState(.InitialState)
        log("Starting BLE manager")
        bleManager = CBCentralManager(delegate:self, queue:nil);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

