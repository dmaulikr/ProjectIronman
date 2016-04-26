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
    @IBOutlet weak var playersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateWithData(challenge:FChallenge){
        let title = "\(challenge.type.rawValue)"
        
        descriptionLabel.text = title
    }

}
