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
class FUserBasicInfo: FModel {
    var deviceConnected:Device?
    var displayName:String?
    var email:String?
    var profileImageURL:String?
    var provider:String?
    
    override func mapToModel(rawData:NSDictionary){
        if let deviceString = rawData["deviceConnected"] as? String {
            self.deviceConnected = Device(rawValue: deviceString)
        }
        
        self.displayName = rawData["displayName"] as? String
        self.email = rawData["email"] as? String
        self.profileImageURL = rawData["profileImageURL"] as? String
        self.provider = rawData["provider"] as? String
    }
    
    override func toDict() -> [String : AnyObject] {
        var dict = [String: AnyObject]()
        
        // testing for nil first becasue some user data might not
        // be available at the same time.
        if self.displayName != nil {
            dict["displayName"] = self.displayName
        }
        if self.email != nil {
            dict["email"] = self.email
        }
        if self.profileImageURL != nil {
            dict["profielImageURL"] = self.profileImageURL
        }
        if self.provider != nil {
            dict["provider"] = self.provider
        }
        if self.deviceConnected != nil {
            dict["deviceConnected"] = self.deviceConnected?.rawValue
        }
    
        return dict
    }
}