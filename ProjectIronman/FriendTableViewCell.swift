//
//  FriendTableViewCell.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 5/4/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!

    @IBAction func leftButtonTapped(sender: UIButton) {
        buttonLeftAction?(button: sender)
    }
    
    @IBAction func rightButtonTapped(sender: UIButton) {
        buttonRightAction?(button: sender)
    }
    
    private var buttonLeftAction: ((button: UIButton) -> Void)?
    private var buttonRightAction: ((button: UIButton) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // friends
    // find friends
    // friend requests
    
    func setUpBasicFriendCell(){
        buttonLeft.hidden = true
        buttonRight.hidden = true
    }
    
    func setUpFindFriendCell(addFriend: (button:UIButton) -> Void){
        buttonLeft.hidden = true
        buttonRight.hidden = false
        buttonRight.setImage(UIImage(named: "addUser.png"), forState: .Normal)
        self.buttonRightAction = addFriend
    }
    
    func setUpFriendRequestCell(decline: (button:UIButton) -> Void,
                                accept: (button:UIButton) -> Void){
        self.buttonLeftAction = decline
        self.buttonRightAction = accept
        
        buttonLeft.hidden = false
        buttonRight.hidden = false
        
        buttonRight.setImage(UIImage(named: "accept.png"), forState: .Normal)
        buttonLeft.setImage(UIImage(named: "decline.png"), forState: .Normal)
    }
}
