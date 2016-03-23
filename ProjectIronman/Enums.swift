//
//  enums.swift
//  FitnessAPI
//
//  Created by Jason Cheng on 3/4/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import Foundation

enum Device: String{
    case NoDevice, Strava, Fitbit, Runkeeper, Runtastic, MapMyRun, NikePlus
}

enum ChallengeType: String{
    case OneVOne, Coop
}

enum ChallengeMode: String{
    case Distance, Speed, Streak
}

enum ChallengeStatus: String{
    case Active, Pending, Completed, Declined
}
