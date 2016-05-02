//
//  LiveChallengeTableViewCell.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 4/5/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class LiveChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     populate live challenge table view cell with appropriate data
    */
    func populateWithData(challenge:FChallenge){
        let header = "\(challenge.type.rawValue) \(challenge.mode.rawValue) \(challenge.completedCondition)"
        headerLabel.text = header
        
        statusLabel.text = challenge.status.rawValue
        userLabel.text = challenge.hostName
        userImage.imageFromUrl(challenge.hostProfileImage)
        
        friendLabel.text = challenge.memberName
        friendImage.imageFromUrl(challenge.memberProfileImage)
    }

}
