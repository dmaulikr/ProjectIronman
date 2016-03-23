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

    init(){
        baseRef = Firebase(url: self.baseURL)
    }
    
    /**
        Check to see if the user has been authenticated
        - Returns: Bool True: user authenticated and token is valid. False: user not authenticated or token has expired needs to reauthorize
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
    
    
    
    /**
        Retrieve user basic info asynchronously. Completion Hander will receive nil
        if no basicInfo or user hasn't been authenticated
        - Parameter completionHandler: pass a NSDictionary back to the call back function
    */
    func getUserBasicInfo(completionHandler: (FUserBasicInfo? -> Void)){
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("users")
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
    
//    func getUserConnectedDevice(completionHandler: Device? -> Void){
//        self.getUserBasicInfo { (basicInfoDict) -> Void in
//            if let basicInfo = basicInfoDict {
//                // if user has connected to a device or app load dash board
//                if let deviceConnected:String = basicInfo["deviceConnected"] as? String {
//                    let device:Device = Device(rawValue: deviceConnected)!
//                    completionHandler(device)
//                }
//                else {
//                    completionHandler(nil)
//                }
//            } else {
//                completionHandler(nil)
//            }
//        }
//    }
    
    func getLatestRun(completionHandler: (NSDictionary -> Void)){
        baseRef.childByAppendingPath("activities")
            .childByAppendingPath(baseRef.authData.uid)
            .childByAppendingPath("run")
            .queryOrderedByChild("startDate")
            .queryLimitedToLast(1)
            .observeSingleEventOfType(.Value, withBlock: {
                (snapshot) -> Void in
                
                for data in snapshot.children {
                    print(data)
                    
                    //pass to FActivity and call completionHandler
                }
                
        })
    }
    
    /**
        Update user
        - Parameter values: the values that you want to add to a new or existing user
    */
    func updateUser(values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("users")
                .childByAppendingPath(baseRef.authData.uid)
                .updateChildValues(values)
            
        }
    }
    
    /**
        Add new running activity to backend
        - Parameter values: the values of a running activity
    */
    func setRunActivity(values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("activities")
                .childByAppendingPath(baseRef.authData.uid)
                .childByAppendingPath("run")
                .childByAutoId()
                .setValue(values)
        }
    }
    
    func setChallenge(values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("challenges")
                .childByAutoId()
                .setValue(values)
        }
    }
    
    func updateChallenge(id: String, values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("challenges")
                .childByAppendingPath(id)
                .updateChildValues(values)
        }
    }
}
