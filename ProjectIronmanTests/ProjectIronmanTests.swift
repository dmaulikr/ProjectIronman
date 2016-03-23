//
//  ProjectIronmanTests.swift
//  ProjectIronmanTests
//
//  Created by Jason Cheng on 2/29/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import XCTest
@testable import ProjectIronman

class ProjectIronmanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testing(){
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
    func challengeMapToModelTest(){
        let testChallengeDict = [
            "type": "OneVOne",
            "mode": "Distance",
            "status": "Active",
            "startTime": 234934934,
            "duration": 4,
            "createdBy": "user123",
            "memberId": "user456",
            "progress": [
                "user123": 5,
                "user456": 3
            ]
        ]
        
        let challenge = FChallenge(rawData: testChallengeDict)
        
        XCTAssertEqual(testChallengeDict["type"], challenge.type.rawValue, "type not the same")
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
