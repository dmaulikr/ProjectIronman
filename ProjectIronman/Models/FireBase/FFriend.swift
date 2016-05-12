//
//  FFriend.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 5/12/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

class FFriend:FModel{
    var id:String!
    var displayName:String!
    var profileImageURL:String?
    
    override func mapToModel(rawData: NSDictionary) {
        self.displayName = rawData["displayName"] as! String
        self.profileImageURL = rawData["profileImageURL"] as? String
    }
    
    override func toDict() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
}