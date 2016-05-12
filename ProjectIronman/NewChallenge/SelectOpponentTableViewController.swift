//
//  SelectOpponentTableViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 5/12/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit
import XLForm

class XLFormFriend: NSObject,  XLFormOptionObject {
    
    let friend: FFriend
    
    init(friend:FFriend){
        self.friend = friend
    }
    
    func formDisplayText() -> String {
        return self.friend.displayName
    }
    
    func formValue() -> AnyObject {
        return self.friend.id
    }
    
}


class SelectOpponentTableViewController: UITableViewController, XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController {

    let cellIdentifier = "friendCell"
    var friends:[FFriend] = []
    
    var rowDescriptor : XLFormRowDescriptor?
    var popoverController : UIPopoverController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "FriendCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier)
        
        FirebaseManager.sharedInstance.getFriendList { (friends) in
            self.friends = friends
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
        return self.friends.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FriendTableViewCell

        let friend = self.friends[indexPath.row]
        cell.populateBasicFriendCell(friend)
        
        if let value = rowDescriptor?.value {
            cell.accessoryType = value.formValue().isEqual(friend.id) ? .Checkmark : .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 104.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friend = friends[indexPath.row]
        
        self.rowDescriptor!.value = XLFormFriend(friend: friend)
        
        // selector animation
        if let porpOver = self.popoverController {
            porpOver.dismissPopoverAnimated(true)
            porpOver.delegate?.popoverControllerDidDismissPopover!(porpOver)
        }
        else if parentViewController is UINavigationController {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
