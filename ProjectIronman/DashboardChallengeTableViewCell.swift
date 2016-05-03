//
//  DashboardChallengeTableViewCell.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 4/22/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class DashboardChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateWithData(challenge:FChallenge){
        let description = "\(challenge.type.rawValue) \(challenge.mode.rawValue)"
        
        descriptionLabel.text = description
        userImage.imageFromUrl(challenge.hostProfileImage)
        userName.text = challenge.hostName
        friendImage.imageFromUrl(challenge.memberProfileImage)
        friendName.text = challenge.memberName
    }
}
