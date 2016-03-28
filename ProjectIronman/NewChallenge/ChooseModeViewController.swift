//
//  ChooseModeViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/28/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class ChooseModeViewController: UIViewController {
    var newChallenge:FChallenge!
    
    @IBAction func distanceModeButtonClick(sender: AnyObject) {
        self.newChallenge.mode = ChallengeMode.Distance
        self.performSegueWithIdentifier("EditChallengeDetails", sender: self)
    }
    
    @IBAction func speedModeButtonClick(sender: AnyObject) {
    }
    
    @IBAction func streakModeButtonClick(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if segue.identifier == "EditChallengeDetails" {
            let destinationController = segue.destinationViewController as! EditDetailViewController
            destinationController.newChallenge = self.newChallenge
        }
    }
}
