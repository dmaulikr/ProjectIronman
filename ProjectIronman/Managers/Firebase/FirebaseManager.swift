//
//  FirebaseManager.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 2/29/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    
    let baseURL:String = "http://projectironman.firebaseIO.com"
    let baseRef:Firebase!
    
    struct Paths {
        static let Users = "users"
        static let Friends = "friends"
        static let Activities = "public_activities"
        static let UserActivities = "user_activities"
        static let Run = "run"
        static let Challenges = "public_challenges"
        static let ChallengeInvitation = "invitation_challenges"
        static let Hosted = "hosted_challenges"
        static let Live = "live_challenges"
        static let Dead = "dead_challenges"
        
//        static let Completed = "completed"
        
    }

    init(){
        baseRef = Firebase(url: self.baseURL)
    }
    
    /**
        Check to see if the user has been authenticated
        - Returns: Bool True: user authenticated and token is valid. 
            False: user not authenticated or token has expired needs to reauthorize
    */
    func isUserAuthenticated() -> Bool{
        var retVal = false //default to not authenticated

        // check if access token has expired
        if baseRef.authData != nil {
            let tokenExpireTime = baseRef.authData.expires
            if tokenExpireTime.doubleValue > NSDate().timeIntervalSince1970 {
                retVal = true
            }
        }
        
        return retVal
    }
    
    func unauth() -> Void {
        baseRef.unauth()
    }
    
    func getUserFirebaseId() -> String? {
        if baseRef.authData != nil {
            return baseRef.authData.uid
        }
        
        return nil
    }
    
//    func getUserFirebaseName() -> String? {
//        if baseRef.authData != nil {
//            
//        }
//    }
    
    /**
        Retrieve user basic info asynchronously. Completion Hander will receive nil
        if no basicInfo or user hasn't been authenticated
        - Parameter completionHandler: pass a NSDictionary back to the call back function
    */
    func getUserBasicInfo(completionHandler: (FUserBasicInfo? -> Void)){
        if baseRef.authData != nil {
            baseRef.childByAppendingPath(Paths.Users)
                .childByAppendingPath(baseRef.authData.uid)
                .observeSingleEventOfType(.Value, withBlock: {
                    snapshot in

                    if let basicInfo = snapshot.value as? NSDictionary {
                        // map raw data to model
                        let userBasicInfo:FUserBasicInfo = FUserBasicInfo(rawData: basicInfo)
                        completionHandler(userBasicInfo)
                    } else {
                        completionHandler(nil) // error feedback to delegate
                    }
                })
        } else {
            completionHandler(nil) // error feedback to delegate
        }
    }
    
    /**
        set the device connected variable after device authorized
    */
    func updateUserDevice(device:String) -> Void {
        updateUser(["deviceConnected": device])
    }
    
    /**
        set the client last sync time between the tracking app/device and 
        our firebase server
    */
    func updateClientLastSyncTime(timeStamp:NSTimeInterval) -> Void {
        updateUser(["clientLastSyncTime": timeStamp])
    }
    
    /**
         Update user
         - Parameter values: the values that you want to add to a new or existing user
    */
    func createNewUser() -> Void {
        if baseRef.authData != nil {
            let providerData = baseRef.authData.providerData
            let newUser = FUserBasicInfo(rawData: providerData)
            newUser.provider = baseRef.authData.provider
            newUser.clientLastSyncTime = 0 // this will allow us to sync all users
                                            //existing activity for the first time
            
            self.updateUser(newUser.toDict())
        }
    }
    
    /**
        Update user
        - Parameter values: the values that you want to add to a new or existing user
    */
    private func updateUser(values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath(Paths.Users)
                .childByAppendingPath(baseRef.authData.uid)
                .updateChildValues(values)
            
        }
    }
    
    func getLatestRun(completionHandler: (FActivity? -> Void)){
        if baseRef.authData != nil {
            baseRef.childByAppendingPath(Paths.UserActivities)
                .childByAppendingPath(baseRef.authData.uid)
                .queryOrderedByChild("startDate")
                .queryLimitedToLast(1)
                .observeSingleEventOfType(.Value, withBlock: {
                    (snapshot) -> Void in
                    
                    var returnActivity:FActivity?
                    if !snapshot.value.isEqual(NSNull){
                        var activity:FActivity?
                        
                        for child in snapshot.children.allObjects as! [FDataSnapshot] {
                            activity = FActivity(rawData: child.value as! NSDictionary)
                        }
                        
                        returnActivity = activity
                    }
                    
                    completionHandler(returnActivity)
                })
        }
    }
    
    /**
     Add new running activity to backend
     - Parameter values: the values of a running activity
     */
    func setRunActivity(values: [NSObject: AnyObject],
                        completionHandler: (() -> Void)?) -> Void {
        
        if baseRef.authData != nil {
            let userId = self.baseRef.authData.uid
            
            // activities/activity_id (public)
            let activityRef = baseRef.childByAppendingPath(Paths.Activities)
                .childByAutoId()
            
            //set user id to activity
            var publicActivityDict = values
            publicActivityDict["userId"] = userId
            publicActivityDict["isNew"] = true
            
            activityRef.setValue(publicActivityDict, withCompletionBlock: {
                (error, ref) in
                
                if error == nil {
                    self.baseRef.childByAppendingPath(Paths.UserActivities)
                        .childByAppendingPath(userId)
                        .childByAppendingPath(activityRef.key)
                        .setValue(values, withCompletionBlock: { (error, ref) in
                            if error == nil { completionHandler?() }
                        })
                }
                
            })
        }
    }

    /**
        return a list of friends
     */
    func getFriendList(completionHandler: [FFriend] -> Void){
        if baseRef.authData != nil {
            let userId = self.baseRef.authData.uid
            baseRef.childByAppendingPath(Paths.Friends)
                .childByAppendingPath(userId)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
                    var friends:[FFriend] = []
                    if !snapshot.value.isEqual(NSNull){
                        for child in snapshot.children.allObjects as! [FDataSnapshot] {
                            let friend = FFriend(rawData: child.value as! NSDictionary)
                            friend.id = child.key
                            friends.append(friend)
                        }
                    }
                    
                    completionHandler(friends)
                })
        }
    }
}
