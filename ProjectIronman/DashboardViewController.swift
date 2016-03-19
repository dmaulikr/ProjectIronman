//
//  DashboardViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/1/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit
import FitnessAPI
import SwiftyJSON

class DashboardViewController: UIViewController, APIManagerActivityDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var fetchButton: UIBarButtonItem!
    
    @IBAction func fetchNewActivities(button: UIButton) {
        // disable fetch button while loading new activites
        fetchButton.enabled = false
        
        APIManager.sharedInstance.fetchActivities()
    }
    
    func activitiesFetched(activities: Array<Activity>?, error: NSError?) {
        fetchButton.enabled = true
        
        if error == nil && activities != nil{
            //loop through activities.
            for activity in activities!{
                
                // TO DO: change time representation of Activity to timestamp (platform agnostic)
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"   
                let date:NSDate = dateFormatter.dateFromString(activity.startDate!)!
                let timeStamp:NSTimeInterval = date.timeIntervalSince1970
                
                // if the any activity date is smaller than last sync time then quit
                if timeStamp < APIManager.sharedInstance.lastSyncTimeStamp {
                    break;
                }
                
                //check to make sure activity is of type Run
                
                // TO DO: Class Activity should be able to do this. map class to dictionary
                // if not then sync everything up firsebase
                let activity:[NSObject: AnyObject] = [
                    "id": activity.id!,
                    "type": activity.type!,
                    "distance": activity.distance!,
                    "pace": activity.pace!,
                    "time": activity.time!,
                    "startDate": activity.startDate!,
                    "timeZone": activity.timeZone!
                ]
                
                FirebaseManager.sharedInstance.updateRunActivity(activity)
                
                //need to make challenge manager listen to activity/run update
                //whenever there's an update challenge manager needs to check
                //if those activities count towards any type of challenges
                
                print(activity)
            }
        } else {
            // update error. show the error in UI somewhere
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.activityDelegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

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
