//
//  EditDetailViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/28/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class EditDetailViewController: UITableViewController {
    var newChallenge:FChallenge!
    
    @IBAction func saveButtonClick(sender: AnyObject) {
        newChallenge.status = ChallengeStatus.Pending
        // fill in other challenge properties for testing purpose
        newChallenge.duration = 3
        newChallenge.createdBy = FirebaseManager.sharedInstance.getUserFirebaseId()
        newChallenge.member = "Friend1"
        newChallenge.startTime = NSDate().timeIntervalSince1970
        
        // saving screen loading
        FirebaseManager.sharedInstance.setChallenge(newChallenge.toDict()) { () -> Void in
            
            //dismiss loading screen
            
            //return to home
            self.performSegueWithIdentifier("UnwindToChallengeHome", sender: self)
        }
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
