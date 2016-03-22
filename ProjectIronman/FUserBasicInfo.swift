//
//  FUserBasicInfo.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/22/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

/**
    Data model for Firebase data
*/
class FUserBasicInfo {
    var deviceConnected:Device?
    var displayName:String?
    var email:String?
    var profileImageURL:String?
    var provider:String?
    
    init(rawData:NSDictionary){
        // usee a map function here
        mapToModel(rawData)
    }
    
    private func mapToModel(rawData:NSDictionary){
        if let deviceString = rawData["deviceConnected"] as? String {
            self.deviceConnected = Device(rawValue: deviceString)
        }
        
        self.displayName = rawData["displayName"] as? String
        self.email = rawData["email"] as? String
        self.profileImageURL = rawData["profileImageURL"] as? String
        self.provider = rawData["provider"] as? String
    }
}