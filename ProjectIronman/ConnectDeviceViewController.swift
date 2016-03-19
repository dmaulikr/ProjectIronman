//
//  ConnectDeviceViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/1/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class ConnectDeviceViewController: UIViewController, APIManagerAuthDelegate {

    // use NSBundle setting to store a variable that indicate whether device
    // has been authorized. 
    var connectingWithDevice:Device?
    
    @IBAction func AuthorizeStrava(sender: AnyObject) {
        connectingWithDevice = Device.Strava
        APIManager.sharedInstance.authorize(Device.Strava)

        // Need somesort of loading UI here
    }
    
    func authorizationComplete() {
        print("auth complete")

        FirebaseManager.sharedInstance.updateUser(["deviceConnected": (connectingWithDevice?.rawValue)!])
        
        //dismiss this view and send to dashboard
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.authDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
