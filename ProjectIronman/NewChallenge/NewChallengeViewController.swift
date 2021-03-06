//
//  NewChallengeViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/28/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class NewChallengeViewController: UIViewController {
    var newChallenge:FChallenge!
    
    @IBAction func oneVOneButton(sender: AnyObject) {
        self.newChallenge.type = ChallengeType.OneVOne
        self.performSegueWithIdentifier("ChooseMode", sender: self)
    }

    @IBAction func coopButton(sender: AnyObject) {
        self.newChallenge.type = ChallengeType.Coop
        self.performSegueWithIdentifier("ChooseMode", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ChooseMode" {
            let destinationController = segue.destinationViewController as! ChooseModeViewController
            destinationController.newChallenge = self.newChallenge
        }
    }


}
