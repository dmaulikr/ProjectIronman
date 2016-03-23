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
        
        let testChallengeDict = [
            "type": "OneVOne",
            "mode": "Distance",
            "status": "Active",
            "startTime": NSDate().timeIntervalSince1970,
            "duration": 4,
            "createdBy": "user123",
            "memberId": "user456",
            "progress": [
                "user123": 5,
                "user456": 3
            ]
        ]
    }
    

    
    func testChallengeMapToModel(){
        let testChallengeDict = [
            "type": "OneVOne",
            "mode": "Distance",
            "status": "Active",
            "startTime": NSDate().timeIntervalSince1970,
            "duration": 4,
            "createdBy": "user123",
            "memberId": "user456",
            "progress": [
                "user123": 5,
                "user456": 3
            ]
        ]
        
        let challenge = FChallenge(rawData: testChallengeDict)
        
        XCTAssertEqual(testChallengeDict["type"] as? String, challenge.type.rawValue, "type not the same")
        XCTAssertEqual(testChallengeDict["mode"] as? String, challenge.mode.rawValue, "mode not the same")
        XCTAssertEqual(testChallengeDict["status"] as? String, challenge.status.rawValue, "status not the same")
        
        XCTAssertEqual(testChallengeDict["startTime"] as? NSTimeInterval, challenge.startTime, "start time not the same")
        XCTAssertEqual(testChallengeDict["duration"] as? Int, challenge.duration)
        XCTAssertEqual(testChallengeDict["createdBy"] as? String, challenge.createdBy)
        
    }
    
    func testChallengeToDict(){
        let testChallengeDict:[String:AnyObject] = [
            "type": "OneVOne",
            "mode": "Distance",
            "status": "Active",
            "startTime": NSDate().timeIntervalSince1970,
            "duration": 4,
            "createdBy": "user123",
            "memberId": "user456",
            "progress": [
                "user123": 5,
                "user456": 3
            ]
        ]
        
        let challenge = FChallenge(rawData: testChallengeDict)
        
        let testDict = challenge.toDict()
        
        print(testDict)

    }
    
//    func FChallengeToDictTest(){
//    }
    
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
