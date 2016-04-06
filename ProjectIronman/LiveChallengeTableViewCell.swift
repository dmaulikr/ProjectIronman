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
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
