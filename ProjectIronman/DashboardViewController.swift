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
import XLPagerTabStrip
import SWRevealViewController


class DashboardViewController: ButtonBarPagerTabStripViewController, APIManagerActivityDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var fetchButton: UIBarButtonItem!
    
    @IBAction func fetchNewActivities(button: UIButton) {
        // disable fetch button while loading new activites
        fetchButton.enabled = false
        
        APIManager.sharedInstance.fetchNewActivities()
    }
    
    func newActivitiesFetched(activities: Array<Activity>?, error: NSError?) {
        fetchButton.enabled = true
        
        if error == nil && activities != nil{
            //loop through activities.
            for activity in activities!{
                
                //check to make sure activity is of type Run
                FirebaseManager.sharedInstance.setRunActivity(activity.toDict(), completionHandler: nil)
            }
            
            //show the latest run stats
            updateLatestRunStats()
            
        } else {
            // update error. show the error in UI somewhere
        }
    }
    
    func updateLatestRunStats() -> Void {
        FirebaseManager.sharedInstance.getLatestRun({ (latestRun) -> Void in
            if let run:FActivity = latestRun {
                self.timeLabel.text = self.formatTime(run.time!)
                
                // convert dsitance to Km or miles
                let km = run.distance! / 1000.0
                self.distanceLabel.text = String(format: "%0.2f km", arguments: [km])
                
                self.paceLabel.text = self.formatPace(run.time!, distance: run.distance!)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ChallengeManager.sharedInstance.checkForCompletedChallenges()
        APIManager.sharedInstance.activityDelegate = self
        updateLatestRunStats()
        
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
    
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = ActiveChallengesTableViewController(style: .Plain, itemInfo: "Active")
        let child_2 = ChildExampleViewController(itemInfo: "Pending")
        let child_3 = ChildExampleViewController(itemInfo: "Completed")
        return [child_1, child_2, child_3]
    }

    
    // MARK: - Time / Distance formatting
    
    private func formatTime(timeInSeconds:Int) -> String {
        var timeString = "-"
        if timeInSeconds > 3600 {
            // get hours
            let hours = timeInSeconds / 3600
            
            // use the remaing second to figure out minutes and seconds
            let remainingSec = timeInSeconds - (3600 * hours)
            
            let minutes = remainingSec / 60
            let seconds = remainingSec % 60
            timeString = String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        } else {
            let minutes = timeInSeconds / 60
            let seconds = timeInSeconds % 60
            timeString = String(format: "%02d:%02d", arguments: [minutes, seconds])
        }
        
        return timeString
    }
    
    private func formatPace(timeInSeconds:Int, distance:Float) -> String{
        // calculate pace
        let pace = Float(timeInSeconds) / distance
        
        // check what is user's default measurement. then convert
        let paceInMinPerKm = convertPaceToMinutePerKilometer(pace)
        
        // needs to separate min and sec to do formatting
        var paceMin = Int(paceInMinPerKm)
        var paceSec = Int(paceInMinPerKm % 1 * 60)
        if paceSec == 60 {
            paceMin += 1
            paceSec = 0
        }
        
        return String(format: "%02d\'%02d\'\'", arguments: [paceMin, paceSec])
    }
    
    private func convertPaceToMinutePerKilometer(pace:Float) -> Float {
        return (pace * 1000) / 60
    }
    
    private func convertPaceToMinutePerMiles(pace:Float) -> Float {
        return (pace * 1000) / (0.621371 * 60)
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
