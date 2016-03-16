//
//  EntranceViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 2/29/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit

class EntranceViewController: UIViewController {

    var currentSegueIdentifier:String!
    let validUserViewIdentifier:String = "LoadMainApp"
    let invalidUserViewIdentifier:String = "LoginFirst"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("container view controller view did load")
        // Check if user is valid here
        
        if FirebaseManager.sharedInstance.isUserAuthenticated() {
            print("load main app")
            self.performSegueWithIdentifier(validUserViewIdentifier, sender: self)
            self.currentSegueIdentifier = self.validUserViewIdentifier

        }
        else {
            print("login first")
            self.performSegueWithIdentifier(self.invalidUserViewIdentifier, sender: self)
            self.currentSegueIdentifier = self.invalidUserViewIdentifier
        }
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
        
        var destinationController:UIViewController!
        
        // TODO: not sure if this block of code is necessary right now. but might 
        // be necessary if destination controller requires data transfer
        if segue.identifier == self.invalidUserViewIdentifier {
            destinationController = segue.destinationViewController
//            destinationController.containerViewController = self
            
        }
        else if segue.identifier == self.validUserViewIdentifier {
            destinationController = segue.destinationViewController
            
//            let fromViewController = self.childViewControllers[0]
//            self.swapFromViewController(fromViewController, toViewController: destinationController)
        }
        
        // if there's something in the container view already
        // we need to transition from that existing view controller to the new controller
        if self.childViewControllers.count > 0 {
            let fromViewController = self.childViewControllers[0]
            self.swapFromViewController(fromViewController, toViewController: segue.destinationViewController)
        }
        // if no view controller is present. need to add one to the view
        else {
            // add the controller to container
            self.addChildViewController(destinationController)
            // add the view
            self.view.addSubview(destinationController.view)
            // assign the parent
            destinationController.didMoveToParentViewController(self)
        }

    }
    
    // remove fromViewController from container view and add the toViewController
    private func swapFromViewController(fromViewController:UIViewController, toViewController:UIViewController){
        
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {
            Bool -> Void in
            // after transition remove old view controller
            fromViewController.removeFromParentViewController()
            
            // assign parent for the new view controller
            toViewController.didMoveToParentViewController(self)
        })
    }
    
    func swapViewControllers(){
        self.currentSegueIdentifier = (self.currentSegueIdentifier == invalidUserViewIdentifier) ? validUserViewIdentifier : invalidUserViewIdentifier
        
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }

}
