//
//  ViewController.swift
//  UberMenu
//
//  Created by Mac on 13/11/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var bleManager: CBCentralManager!;
    var peripheral: CBPeripheral!;
    var rawMenu   : String="";
    var menu      : Menu!;


    @IBOutlet weak var debugView: UITextView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuArea: UITextView!
    
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
            
                self.navigationItem.title = name
                
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
            
            let currentString = String(CString: pointer, encoding: NSASCIIStringEncoding )!
            
            
            if( currentString.containsString("--==--") ){
                self.menu = Menu(rawMenu)
                presentMenu()
            }
            
            rawMenu += currentString;
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
        bleManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func stopScanning(){
        bleManager.stopScan()
    }
    
    func presentMenu(){
        if let attributedMenu = self.menu.attributedText(){
            menuArea.attributedText = attributedMenu
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UITextArea doesn't support changing text and keeping the formatting
        //when the TextArea is set as selectable false in the IB
        menuArea.selectable = false;
        
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "go_to_table" {
            (segue.destinationViewController as! MenuTableViewController).dataSource = self.menu
        }
    }
}

