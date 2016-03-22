//
//  APIManager.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/3/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation
import FitnessAPI

/**
    choosing to use delegates for APIManager because it just seems cleaner whe
    used in view controllers. Block call back works, but it gets kind of messy
*/
@objc protocol APIManagerAuthDelegate{
    func authorizationComplete() -> Void
    optional func deauthorizationComplete() -> Void
}

protocol APIManagerActivityDelegate{
   func newActivitiesFetched(activities: Array<Activity>?, error: NSError?) -> Void
}

/**
    This class will take care of handling the different API libraries. It will
    choose the right api library to use and update activity data to firebase db
    appropriately
*/
public class APIManager {
    public static let sharedInstance = APIManager()
    var lastSyncTimeStamp:NSTimeInterval = 0
    private var currentAPIClient: Client?
    var authDelegate:APIManagerAuthDelegate?
    var activityDelegate:APIManagerActivityDelegate?
    
    // api manager needs to know what device the user is connected to or
    // is going to connect to
    
    // APIManager's task is to delicate work to the appropriate api library. THAT IS IT
    
    init(){
        // first need to find out which device or app the user is using
        // get from Firebase
        // set the appropriate currentAPIClient
        FirebaseManager.sharedInstance.getUserBasicInfo { (basicInfo) -> Void in
            if let device = basicInfo?.deviceConnected {
                self.setCurrentAPIClient(device)
            }
        }
    }
    
    func handleURL(url:NSURL) {
        currentAPIClient?.handleRedirectURL(url)
    }
    
    func deauthorize(){
        currentAPIClient?.deauthorize()
        self.authDelegate?.deauthorizationComplete?()
    }
    
    /**
     Should probably only be called when user is authorizing for the first time.
     */
    func authorize(deviceConnected:Device = .NoDevice){
        self.setCurrentAPIClient(deviceConnected)
        currentAPIClient?.authorize({ () -> Void in
            self.authDelegate?.authorizationComplete()
        })
    }
    
    /**
     
    */
    func fetchNewActivities(){
        // need to consider last time sync here
        currentAPIClient?.fetchActivities(completionHandler: { (activities, error) -> Void in
            var activityList = Array<Activity>()
            
            // sort out all the old activities. TO DO: if the apis handle querying with dates than
            // maybe we should let them do it
            if error == nil && activities != nil {
                for activity in activities! {
                    if activity.startDate > self.lastSyncTimeStamp {
                        activityList.append(activity)
                    }
                }
                
                // update last sync timestamp
                self.lastSyncTimeStamp = NSDate().timeIntervalSince1970
            }
            
            
            self.activityDelegate?.newActivitiesFetched(activityList, error: error)
        })
    }
    
    /**
        set the current api client. so manager can refer to you for future use
     */
    private func setCurrentAPIClient(deviceConnected:Device){
        switch deviceConnected{
        case .Strava:
            if currentAPIClient == nil {
                currentAPIClient = StravaClient.sharedInstance as Client
            }
            break
        case .Runkeeper:
            if currentAPIClient == nil {
                currentAPIClient = RunKeeperClient.sharedInstance as Client
            }
            break
        default:
            //set the currentAPIClient to the one store in Firebase
            break
        }
    }

    
}