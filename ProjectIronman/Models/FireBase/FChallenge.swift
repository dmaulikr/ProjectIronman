//
//  FChallenge.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/23/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

class FChallenge: FModel{
    var type:ChallengeType!
    var mode:ChallengeMode!
    var status:ChallengeStatus!
    var createTime:NSTimeInterval! // when challenge is created in UTC timestamp
    var startTime:NSTimeInterval? // when challenge is accepted. only be set when challenge is accepted by member
    var duration:Int! // how many days
    var completedCondition:Int! // the condition that the challenge will be regarded as completed. Ex. 5km or  5 min/km
    private var progress:[NSObject:AnyObject] = [NSObject:AnyObject]() // Dictionary<userId, progress>
    // winning condition?
    
    var createdBy:String! {
        // make sure progress dict is initialized with this userId as well
        didSet {
            if progress[createdBy] == nil {
                progress[createdBy] = 0
            }
        }
    }
    
    var member:String! {
        didSet {
            if progress[member] == nil {
                progress[member] = 0
            }
        }
    }
    
    
    /**
        update user progress with value
        - Parameter value: this value can be distance, speed, or streak depending on what challenge type and challenge mode
    */
    func updateProgress(userId:String, value:AnyObject){
        if progress[userId] != nil {
            progress[userId] = value
        }
    }
    
    /**
        return user progress
    */
    func getProgress(userId:String) -> AnyObject?{
        if let userProgress = progress[userId] {
            return userProgress
        }
        return nil
    }
    
    override func mapToModel(rawData: NSDictionary){
        self.type = ChallengeType(rawValue: rawData["type"] as! String)
        self.mode = ChallengeMode(rawValue: rawData["mode"] as! String)
        self.status = ChallengeStatus(rawValue: rawData["status"] as! String)
        self.createTime = rawData["createDate"] as! NSTimeInterval
        self.duration = rawData["duration"] as! Int
        self.completedCondition = rawData["completedCondition"] as! Int
        self.createdBy = rawData["createdBy"] as! String
        self.member = rawData["member"] as! String
        self.progress = rawData["progress"] as! [NSObject:AnyObject]
    }
    
    override func toDict() -> [String : AnyObject] {
        var returnDict:[String: AnyObject] = [
            "type": self.type.rawValue,
            "mode": self.mode.rawValue,
            "status": self.status.rawValue,
            "createDate": self.createTime,
            "duration": self.duration,
            "completedCondition": self.completedCondition,
            "createdBy": self.createdBy,
            "member": self.member,
            "progress": self.progress
        ]
        
        if let startTime = self.startTime {
            returnDict["startDate"] = startTime
        }
        
        return returnDict
    }
}