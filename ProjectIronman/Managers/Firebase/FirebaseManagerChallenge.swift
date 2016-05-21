//
//  FirebaseManagerChallenge.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 5/18/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation
import Firebase

// FirebaseManagerChallenge
extension FirebaseManager{
    
    /**
        Get active challenges that the user has
        - Parameter completionHandler: function to handle the array of FChallenge
    */
    func getActiveChallenges(completionHandler: ([FChallenge] -> Void)){
        getLiveChallenges(completionHandler, specificPath: Paths.Active)
    }
    
    /**
        Get all pending challenges
        - Parameter completionHandler: function to handle the array of FChallenge
    */
    func getPendingChallenges(completionHandler: ([FChallenge] -> Void)){
        getLiveChallenges(completionHandler, specificPath: Paths.Pending)
    }
    
    /**
     Return all the challenge invitations
     - Parameter completionHandler: function to handle the Array of FChallenge
     */
    func getInvitationChallenges(completionHandler: ([FChallenge] -> Void)){
        if baseRef.authData != nil {
            baseRef.childByAppendingPath(Paths.ChallengeInvitation)
                .childByAppendingPath(baseRef.authData.uid)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    self.getChallenges(snapshot, completionHandler: completionHandler)
                })
        }
    }
    
    private func getLiveChallenges(completionHandler: ([FChallenge] -> Void), specificPath: String){
        if baseRef.authData != nil {
            // get all live challenge Id of the user
            baseRef.childByAppendingPath(Paths.Live)
                .childByAppendingPath(baseRef.authData.uid)
                .childByAppendingPath(specificPath)
                .observeSingleEventOfType(.Value, withBlock: {
                    (snapshot) in
                    
                    self.getChallenges(snapshot, completionHandler: completionHandler)
                })
        }
    }
    
    /**
        Go through a snapshot to retrieve detail information of the challenges
    */
    private func getChallenges(snapshot:FDataSnapshot, completionHandler: ([FChallenge] -> Void)){
        var returnChallenges:[FChallenge] = []
        if !snapshot.value.isEqual(NSNull){
            
            // loop through all challenges and get the challenge Id
            for challenge in snapshot.children {
                let challengeId = challenge.key
                
                // get challenge info from the challenge Id
                self.baseRef.childByAppendingPath(Paths.Challenges)
                    .childByAppendingPath(challengeId)
                    .observeSingleEventOfType(.Value, withBlock: {
                        (snapshot) in
                        
                        if let valueDict = snapshot.value as? NSDictionary {
                            let challenge = FChallenge()
                            challenge.mapToModelWithId(valueDict, id: snapshot.key)
                            returnChallenges.append(challenge)
                        }
                        
                        completionHandler(returnChallenges)
                    })
            }
        } else { completionHandler(returnChallenges) }
    }
    
    /**
        Add new challenge. Whenever a challenge is created. the challengeId
        is also added to pending table and the hosted table
     
        - Parameter challenge: the new challenge that is going to be created
    */
    func createNewChallenge(challenge: FChallenge,
                            completionHandler: (() -> Void)?) {
        if baseRef.authData != nil {
            let challengeRef = baseRef.childByAppendingPath(Paths.Challenges)
                .childByAutoId()
            
            challengeRef.setValue(challenge.toDict(), withCompletionBlock: {
                (error, ref) -> Void in
                let userId = self.baseRef.authData.uid
                let friendId = challenge.memberId
                
                // set id to hosted/user_id/challenge_id
                let hostedPath:String = "\(Paths.Hosted)/\(userId)/\(challengeRef.key)"
                
                // set id to live/user_id/pending/challenge_id
                let livePath:String = "\(Paths.Live)/\(userId)/\(Paths.Pending)/\(challengeRef.key)"
                
                //invitation_challenges/user_id/challenge_id
                let invitationPath:String = "\(Paths.ChallengeInvitation)/\(friendId)/\(challengeRef.key)"
                
                self.baseRef.updateChildValues([
                    hostedPath: true,
                    livePath: true,
                    invitationPath: true
                    ],
                    withCompletionBlock: { (error, ref) -> Void in
                        if error == nil { completionHandler?() }
                })
            })
        }
    }
    
    func acceptChallenge(challenge:FChallenge, completionHandler:()->Void){
        
        let userId = self.baseRef.authData.uid
        // host... pending -> active (maybe do this from backend...listen to change in public challenge)
        
        // member... invitation -> live_active
        let invitationPath:String = "\(Paths.ChallengeInvitation)/\(challenge.memberId)/\(challenge.id)"
        let livePath:String = "\(Paths.Live)/\(userId)/\(Paths.Pending)/\(challenge.id)"
        
        self.baseRef.updateChildValues([
            invitationPath: NSNull(),
            livePath: true
            ],
            withCompletionBlock:{ (error, ref) -> Void in
                completionHandler()
        })
        
        // public challenge status... pending -> active
        updateChallenge(challenge.id!, values: ["status": "Active"], completionHandler: nil)
    }
    
    /**
        Update challenge
    */
    private func updateChallenge(id: String, values: [NSObject: AnyObject],
                         completionHandler: (() -> Void)?) {
        
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

}