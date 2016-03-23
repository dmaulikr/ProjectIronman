//
//  FActivity.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/22/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

class FActivity {
    var id:String?
    var type:String?
    var distance:Float?
    var time:Int?
    var startDate:NSTimeInterval?
    var timeZone:String?

    init(rawData:NSDictionary){
        // usee a map function here
        mapToModel(rawData)
    }
    
    private func mapToModel(rawData:NSDictionary){
        self.id = rawData["id"] as? String
        self.type = rawData["type"] as? String
        self.distance = rawData["distance"] as? Float
        self.time = rawData["time"] as? Int
        self.startDate = rawData["startDate"] as? NSTimeInterval
        self.timeZone = rawData["timeZone"] as? String
    }
}