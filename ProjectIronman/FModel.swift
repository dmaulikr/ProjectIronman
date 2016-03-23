//
//  FModel.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/23/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

/**
    Base class for all firebase models
*/
class FModel {
    init(rawData: NSDictionary){
        mapToModel(rawData)
    }
    
    func mapToModel(rawData: NSDictionary){
        fatalError("Child class needs to override this method")
    }
    
    func toDict() -> [String:AnyObject]{
        fatalError("Child class needs to override this method")
    }
}