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
        - Returns: Bool
    */
    func isUserAuthenticated() -> Bool{
        var retVal = false //default to not authenticated

        if baseRef.authData != nil {
            retVal = true
        }
        
        return retVal
    }
    
    func unauth() -> Void {
        baseRef.unauth()
    }
    
    /**
        Retrieve user basic info asynchronously
        - Parameter completionHandler: pass a NSDictionary back to the call back function
    */
    func getUserBasicInfo(completionHandler: (NSDictionary? -> Void)){
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("users")
                .childByAppendingPath(baseRef.authData.uid)
                .childByAppendingPath("basicInfo")
                .observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                    if let basicInfo = snapshot.value as? NSDictionary {
                        completionHandler(basicInfo)
                    } else {
                        completionHandler(nil)
                    }
                })
        } else {
            completionHandler(nil)
        }
    }
    
    func getLatestRun(completionHandler: (NSDictionary -> Void)){
        baseRef.childByAppendingPath("users")
            .childByAppendingPath(baseRef.authData.uid)
            .childByAppendingPath("activities/running")
            .queryOrderedByChild("timestamp")
            .observeSingleEventOfType(.Value, withBlock: {
                (snapshot) -> Void in
                
                
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
                .childByAppendingPath("basicInfo")
                .updateChildValues(values)
            
        }
    }
    
    /**
        Add new running activity to backend
        - Parameter values: the values of a running activity
    */
    func updateRunActivity(values: [NSObject: AnyObject]) -> Void {
        if baseRef.authData != nil {
            baseRef.childByAppendingPath("users")
                .childByAppendingPath(baseRef.authData.uid)
                .childByAppendingPath("activities/running")
                .childByAutoId()
                .updateChildValues(values)
        }
    }
}
