//
//  ConnectDeviceViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/1/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class ConnectDeviceViewController: UIViewController {

    @IBAction func AuthorizeStrava(sender: AnyObject) {
//        StravaClient.sharedInstance.authTokenCompletionHandler = {
//            error -> Void in
//            
//            if error == nil {
//                // once received start a segue back to the main app
//                print("auth token received")
//                
//                let userData = ["deviceConnected": "Strava"]
//                FirebaseManager.sharedInstance.updateUser(userData)
//            }
//            
//        }
//        
//        StravaClient.sharedInstance.authorize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
