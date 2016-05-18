//
//  FirebaseManagerTests.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/24/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import XCTest
import FitnessAPI
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

    func testCreateNewPendingChallenge(){
        let testChallenge = FChallenge()
        testChallenge.type = ChallengeType.OneVOne
        testChallenge.mode = ChallengeMode.Distance
        testChallenge.status = ChallengeStatus.Pending
        testChallenge.completedCondition = 3 //3km race
        testChallenge.createTime = NSDate().timeIntervalSince1970
        testChallenge.duration = 3
        testChallenge.hostId = "facebook:10153784008215971"
        testChallenge.hostName = "Jason Cheng"
        testChallenge.hostProfileImage = "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12742803_10153767482015971_4404060236400761591_n.jpg?oh=2181a763507eea93638d11cb8fc874e2&oe=57A73253"
        
        testChallenge.memberId = "friend1"
        testChallenge.memberName = "Nancy Wang"
        testChallenge.memberProfileImage = "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12742803_10153767482015971_4404060236400761591_n.jpg?oh=2181a763507eea93638d11cb8fc874e2&oe=57A73253"
        let expectation = self.expectationWithDescription("pending challenge has been created")
        FirebaseManager.sharedInstance.createNewChallenge(testChallenge) { () -> Void in
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1.5, handler: .None)
    }
    
    func testCreateNewActiveChallenge(){
        let testChallenge = FChallenge()
        testChallenge.type = ChallengeType.OneVOne
        testChallenge.mode = ChallengeMode.Distance
        testChallenge.status = ChallengeStatus.Active
        testChallenge.completedCondition = 3000 //3km race
        testChallenge.createTime = NSDate().timeIntervalSince1970
        testChallenge.startTime = NSDate().timeIntervalSince1970
        testChallenge.duration = 3
        testChallenge.hostId = "facebook:10153784008215971"
        testChallenge.hostName = "Jason Cheng"
        testChallenge.hostProfileImage = "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12742803_10153767482015971_4404060236400761591_n.jpg?oh=2181a763507eea93638d11cb8fc874e2&oe=57A73253"
        
        testChallenge.memberId = "friend1"
        testChallenge.memberName = "Nancy Wang"
        testChallenge.memberProfileImage = "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12742803_10153767482015971_4404060236400761591_n.jpg?oh=2181a763507eea93638d11cb8fc874e2&oe=57A73253"
        
        let expectation = self.expectationWithDescription("active challenge has been created")
        FirebaseManager.sharedInstance.createNewChallenge(testChallenge) { () -> Void in
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1.5, handler: .None)
    }
    
    /**
        create new activity to be sync with firebase. 
        using this to test the backend server code
    */
    func testCreateActivity(){

        let activityDict = [
            "id": "Strava_activtytest",
            "type": "run",
            "distance": 5000,
            "time": 3600,
            "startDate": NSDate().timeIntervalSince1970,
            "timeZone": "PDT"
        ]
        
        let expectation = self.expectationWithDescription("new activity has been created")
        FirebaseManager.sharedInstance.setRunActivity(activityDict as [NSObject : AnyObject]) {
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1.5, handler: .None)
    
    }
    
    func testCreateOutdatedActivity(){
//        1460301075 ...april 10
        let newActivity = FActivity()
        newActivity.id = "Strava_testoutdatedactivity"
        newActivity.distance = 5000.0
        newActivity.startDate = NSTimeInterval(1460301075)
        newActivity.time = 3000
        newActivity.timeZone = "PDT"
        
        let expectation = self.expectationWithDescription("new activity has been created")
        FirebaseManager.sharedInstance.setRunActivity(newActivity.toDict()) {
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1.5, handler: .None)
    }
    
    
}
