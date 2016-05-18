//
//  FModelTests.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/23/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import XCTest
@testable import ProjectIronman

class FModelTests: XCTestCase{
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testChallengeModel(){
        let testChallengeDict = [
            "type": "OneVOne",
            "mode": "Distance",
            "status": "Active",
            "createDate": NSDate().timeIntervalSince1970,
            "duration": 4,
            "completedCondition": 3,
            "hostId": "user123",
            "hostName": "Jason Cheng",
            "hostProfileImage": "http://image.com",
            "memberName": "user456",
            "memberId": "Jack Lantern",
            "memberProfileImage": "http://image2.com",
            "progress": [
                "user123": 5,
                "user456": 3
            ]
        ]
        
        let challenge = FChallenge(rawData: testChallengeDict)
        let challengeDict = challenge.toDict()
        
        let keys = testChallengeDict.allKeys
        
        for key in keys as! [String]{
            XCTAssert(testChallengeDict[key]!.isEqual(challengeDict[key]!), "\(key) not the same")
        }
    }
    
    func testValidActivityModel(){
        let activityDict = [
            "id": "starva_w2ioef",
            "type": "run",
            "distance": 3000.0,
            "time": 30000,
            "startDate": NSDate().timeIntervalSince1970,
            "timeZone": "PDT"
        ]
        
        let activity = FActivity(rawData: activityDict)
        
        XCTAssert(activity.id == activityDict["id"] as? String)
        XCTAssert(activity.type == activityDict["type"] as? String)
        XCTAssert(activity.distance == activityDict["distance"] as? Float)
        XCTAssert(activity.time == activityDict["time"] as? Int)
        XCTAssert(activity.startDate == activityDict["startDate"] as? NSTimeInterval)
        XCTAssert(activity.timeZone == activityDict["timeZone"] as? String)
    }
    
    func testFriendModel(){
        let friendDict = [
            "displayName": "Jason Cheng",
            "profileImageURL": "https://image.com"
        ]
        
        let friend = FFriend(rawData: friendDict)
        
        XCTAssert(friend.displayName == friendDict["displayName"])
        XCTAssert(friend.profileImageURL == friendDict["profileImageURL"])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
