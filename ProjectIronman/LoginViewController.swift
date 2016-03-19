//
//  LoginViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 2/29/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    @IBAction func LoginWithFB(sender: UIButton) {
        let ref = Firebase(url: FirebaseManager.sharedInstance.baseURL)
        
        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            
                            // create new user
                            let providerData = authData.providerData
                            let newUser:[String:AnyObject] = [
                                "provider": authData.provider,
                                "displayName": providerData["displayName"]!,
                                "email": providerData["email"]!,
                                "profileImageURL": providerData["profileImageURL"]!
                            ]
                            
                            FirebaseManager.sharedInstance.updateUser(newUser)
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                })
            }

        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.parentViewController)
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
    }


}
