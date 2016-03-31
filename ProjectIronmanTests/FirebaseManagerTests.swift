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

    func testCreateNewChallenge(){
        let testChallenge = FChallenge()
        testChallenge.type = ChallengeType.OneVOne
        testChallenge.mode = ChallengeMode.Distance
        testChallenge.status = ChallengeStatus.Pending
        testChallenge.startTime = NSDate().timeIntervalSince1970
        testChallenge.duration = 3
        testChallenge.createdBy = "Test1"
        testChallenge.member = "User1"
        
        let expectation = self.expectationWithDescription("challenge has been created")
        FirebaseManager.sharedInstance.createNewChallenge(testChallenge.toDict()) { () -> Void in
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1.5, handler: .None)
    }
    
    
}
