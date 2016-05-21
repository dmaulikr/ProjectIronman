//
//  InvitationChallengeTableViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 5/21/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class InvitationChallengeTableViewController: UITableViewController {
    var invitationChallenges: [FChallenge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseManager.sharedInstance.getInvitationChallenges { (challenges) in
            self.invitationChallenges = challenges
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.invitationChallenges.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InvitationChallengeCell", forIndexPath: indexPath) as! InvitationChallengeTableViewCell

        let challenge = self.invitationChallenges[indexPath.row]
        cell.populateWithData(challenge) { 
            self.tableView.reloadData()
        }
        
        // Configure the cell...

        return cell
    }   
}
