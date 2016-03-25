//
//  FirebaseManagerTests.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/24/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import XCTest
@testable import ProjectIronman

class FirebaseManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetChallenge(){
        let testChallenge = FChallenge()
        testChallenge.type = ChallengeType.OneVOne
        testChallenge.mode = ChallengeMode.Distance
        testChallenge.status = ChallengeStatus.Active
        testChallenge.startTime = NSDate().timeIntervalSince1970
        testChallenge.duration = 3
        testChallenge.createdBy = "Test1"
        testChallenge.member = "User1"
        
        let expectation = self.expectationWithDescription("challenge has been created")
        FirebaseManager.sharedInstance.setChallenge(testChallenge.toDict()) { () -> Void in
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1.5, handler: .None)
    }
    
//    func testUpdateChallenge(){
//        let challengeId = "-KDiu89MAyh3dmVROrdb"
//        
//        let testChallenge = FChallenge()
//        testChallenge.type = ChallengeType.OneVOne
//        testChallenge.mode = ChallengeMode.Distance
//        testChallenge.status = ChallengeStatus.Completed
//        testChallenge.startTime = NSDate().timeIntervalSince1970
//        testChallenge.duration = 3
//        testChallenge.createdBy = "Test1"
//        testChallenge.member = "User1"
//        
//        let expectation = self.expectationWithDescription("challenge has been updated")
//        FirebaseManager.sharedInstance.updateChallenge(challengeId, values: testChallenge.toDict()) { () -> Void in
//            expectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(1.5, handler: .None)
//    }
//    
//    func testSetPendingChallenge(){
//        let challengeId = "-KDiu89MAyh3dmVROrdb"
//        
//        let expectation = self.expectationWithDescription("pending challenge set")
//        FirebaseManager.sharedInstance.setPendingChallenge(challengeId) { () -> Void in
//            expectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(1.5, handler: .None)
//        
//    }
}
