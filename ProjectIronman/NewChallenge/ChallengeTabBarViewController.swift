//
//  ChallengeTabBarViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/28/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class ChallengeTabBarViewController: UITabBarController {

    @IBAction func createNewChallenge(sender: AnyObject) {
        self.performSegueWithIdentifier("CreateNewChallenge", sender: self)
    }
    
    @IBAction func unwindToChallengeHome(unwindSegue: UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 0
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        


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
        if segue.identifier == "CreateNewChallenge" {
            let destinationController = segue.destinationViewController as! NewChallengeViewController
            destinationController.newChallenge = FChallenge()
        }
        
    }
    

}
