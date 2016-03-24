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
    var startTime:NSTimeInterval! // start time in UTC timestamp
    var duration:Int! // how many days
    var createdBy:String! // user id
    var memberId:String! //member id
    private var progress:[NSObject:AnyObject]! // Dictionary<userId, progress>
    // winning condition?
    
    func updateProgress(userId:String, value:AnyObject){
        if progress[userId] != nil {
            progress[userId] = value
        }
    }
    
    func getProgress(userId:String) -> Int{
        return progress[userId] as! Int
    }
    
    override func mapToModel(rawData: NSDictionary){
        self.type = ChallengeType(rawValue: rawData["type"] as! String)
        self.mode = ChallengeMode(rawValue: rawData["mode"] as! String)
        self.status = ChallengeStatus(rawValue: rawData["status"] as! String)
        self.startTime = rawData["startTime"] as! NSTimeInterval
        self.duration = rawData["duration"] as! Int
        self.createdBy = rawData["createdBy"] as! String
        self.memberId = rawData["memberId"] as! String
        
//        let progressDict = rawData["progress"] as! [NSObject: AnyObject]
        self.progress = rawData["progress"] as! [NSObject:AnyObject]
    }
    
    override func toDict() -> [String : AnyObject] {
        return [
            "type": self.type.rawValue,
            "mode": self.mode.rawValue,
            "status": self.status.rawValue,
            "startTime": self.startTime,
            "duration": self.duration,
            "createdBy": self.createdBy,
            "memberId": self.memberId,
            "progress": self.progress
        ]
    }
}