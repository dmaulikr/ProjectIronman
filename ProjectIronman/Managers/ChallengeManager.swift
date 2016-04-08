//
//  ChallengeManager.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/16/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

class ChallengeManager {
    static let sharedInstance = ChallengeManager()
    
    /**
        listens to new activities added event from firebase.
        check if the new activity is counted towards any challenges
    */
    func checkForCompletedChallenges() {
        FirebaseManager.sharedInstance.observeNewActivityAdded { activity in
            if let newActivity = activity {
                
                // get all the active challenges and update the progress
                
                
                
            }
        }
    }
    //need to make challenge manager listen to activity/run update
    //whenever there's an update challenge manager needs to check
    //if those activities count towards any type of challenges
}