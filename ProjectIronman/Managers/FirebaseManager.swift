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
        static let Activities = "activities"
        static let Run = "run"
        static let Challenges = "challenges"
        static let Hosted = "hosted"
        static let Live = "live"
        static let Dead = "dead"
        static let Pending = "pending"
        static let Active = "active"
        static let Completed = "completed"
        
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
            baseRef.childByAppendingPath(Paths.Activities)
                .childByAppendingPath(baseRef.authData.uid)
                .childByAppendingPath(Paths.Run)
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
    func setRunActivity(values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath(Paths.Activities)
                .childByAppendingPath(baseRef.authData.uid)
                .childByAppendingPath(Paths.Run)
                .childByAutoId()
                .setValue(values)
        }
    }
    
    /**
        Add new challenge. Whenever a challenge is created. the challengeId
        is also added to pending table and the hosted table
     
        - Parameter
    */
    func createNewChallenge(values: [NSObject: AnyObject],
        completionHandler: (() -> Void)?) -> Void {
        if baseRef.authData != nil {
            let challengeRef = baseRef.childByAppendingPath(Paths.Challenges)
                                .childByAutoId()
            
            challengeRef.setValue(values, withCompletionBlock: {
                (error, ref) -> Void in
                let userId = self.baseRef.authData.uid
                // set id to hosted/user_id/challenge_id
                let hostedPath:String = "\(Paths.Hosted)/\(userId)/\(challengeRef.key)"
                // set id to live/user_id/pending/challenge_id
                let livePath:String = "\(Paths.Live)/\(userId)/\(Paths.Pending)/\(challengeRef.key)"
                
                self.baseRef.updateChildValues([
                        hostedPath: true,
                        livePath: true
                    ],
                    withCompletionBlock: { (error, ref) -> Void in
                        if error == nil { completionHandler?() }
                })
            })
        }
    }
    
    //
    
    /**
        Update challenge
    */
    func updateChallenge(id: String, values: [NSObject: AnyObject],
        completionHandler: (() -> Void)?) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath(Paths.Challenges)
                .childByAppendingPath(id)
                .updateChildValues(values, withCompletionBlock: { (error, ref) -> Void in
                    if error == nil {
                        completionHandler?()
                    }
                })
        }
    }
    
//    func setPendingChallenge(id:String, completionHandler: (() -> Void)?) -> Void {
//        if baseRef.authData != nil {
//            baseRef.childByAppendingPath("pending")
//                .childByAppendingPath(baseRef.authData.uid)
//                .childByAppendingPath(id)
//                .setValue(true, withCompletionBlock: { (error, ref) -> Void in
//                    if error == nil {
//                        completionHandler?()
//                    }
//                })
//        }
//    }
//    
//    
//    func updatePendingToActive(id:String) -> Void {
//        //test if id is in pending
//        //move id to active
//        //remove id from pending
//        
//    }
//    
//    func updateInvitationToActive(id:String) -> Void {
//    }
//    
//    func updatePendingToDeclined(id:String) -> Void {
//    }
//    
//    func updateActiveToCompleted(id:String) -> Void {
//    }
}
