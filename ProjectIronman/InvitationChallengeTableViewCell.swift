//
//  InvitationChallengeTableViewCell.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 5/21/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class InvitationChallengeTableViewCell: UITableViewCell {
    var challenge:FChallenge!
    
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    @IBAction func acceptChallenge(sender: UIButton) {
        sender.enabled = false
        declineButton.enabled = false
        
        FirebaseManager.sharedInstance.acceptChallenge(self.challenge) { 
            self.challengeAcceptedCallback()
        }
    }
    
    @IBAction func declineChallenge(sender: UIButton) {
    
    }
    
    private var challengeAcceptedCallback: (()->Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateWithData(challenge:FChallenge, challengeAcceptedCallback: ()->Void){
        self.challenge = challenge
        self.challengeAcceptedCallback = challengeAcceptedCallback
        
        challengeLabel.text = "\(challenge.memberName) has challenged you to a run"
    }

}
