//
//  SplashController.swift
//  UberMenu
//
//  Created by Mac on 17/11/15.
//  Copyright © 2015 samuraibonzai. All rights reserved.
//

import UIKit

class SplashController: UIViewController
{
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:"moveToLobby:", userInfo: nil, repeats:false)
    }
    
    func moveToLobby(userInfo:AnyObject)
    {
        self.performSegueWithIdentifier("go_to_main", sender: self)
    }
}
