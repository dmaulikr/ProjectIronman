//
//  FirebaseObservers.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/31/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

/**
    FirebaseObservers. Where the observers are set and removed
*/
extension FirebaseManager {
    /**
        Set an observer for child added event
        - Returns: observer handle Id
     */
    func observeHostedChallenge(complitionHandler: (FChallenge? -> Void)) -> UInt? {
        var handle:UInt?
        if baseRef.authData != nil {
            let userId = baseRef.authData.uid
            handle = baseRef.childByAppendingPath(Paths.Hosted)
                .childByAppendingPath(userId)
                .observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    print(snapshot.key)
                    let challengeId = snapshot.key
                    let challengeQueryRef = self.baseRef.childByAppendingPath(Paths.Challenges)
                                                .childByAppendingPath(challengeId)
                    challengeQueryRef.observeSingleEventOfType(.Value, withBlock: { (querySnapshot) -> Void in
//                        print(querySnapshot)
                        
                        if let valueDict = querySnapshot.value as? NSDictionary {
//                            print(valueDict)
                            let challenge = FChallenge(rawData: valueDict)
                            complitionHandler(challenge)
                        } else {
                            complitionHandler(nil)
                        }
                    })
                })
        }
        return handle
    }
    
    /**
        Listen to new activity added
        - Returns: observer handle Id
    */
    func observeNewActivityAdded(completionHandler: (FActivity? -> Void)) -> UInt? {
        var handle:UInt?
        
        if baseRef.authData != nil {
            let userId = baseRef.authData.uid
            handle = baseRef.childByAppendingPath(Paths.Activities)
                .childByAppendingPath(userId)
                .childByAppendingPath(Paths.Run)
                .observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    var returnActivity:FActivity?
                    if !snapshot.value.isEqual(NSNull) {
                        if let activityDict = snapshot.value as? NSDictionary {
                            returnActivity = FActivity(rawData: activityDict)
                        }
                    }
                    
                    completionHandler(returnActivity)
                    
                })
        }
        
        return handle
    }
    
    // observeActiveChallenges
    // observePendingChallenges
    // observeCompletedChallenges
    
    func removeObserverWith(handle:UInt?) -> Void {
        if handle != nil && baseRef.authData != nil {
            baseRef.removeObserverWithHandle(handle!)
        }
    }
    
    func removeAllObservers() -> Void {
        baseRef.removeAllObservers()
    }

}
