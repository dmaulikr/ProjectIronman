//
//  EditDetailViewController.swift
//  ProjectIronman
//
//  Created by Jason Cheng on 3/28/16.
//  Copyright © 2016 Jason. All rights reserved.
//

import UIKit
import XLForm
import SVProgressHUD

class EditDetailViewController: XLFormViewController {
    private struct Tags {
        static let Title = "title"
        static let ChallengeType = "type"
        static let Mode = "mode"
        static let Distance = "distance"
        static let Duration = "duration"
    }

    var newChallenge:FChallenge!
    var detailForm:XLFormDescriptor = XLFormDescriptor(title: "challenge details")

    
    @IBOutlet weak var distanceLabel: UITextField!
    @IBAction func saveButtonClick(sender: UIBarButtonItem) {
        sender.enabled = false
        SVProgressHUD.show()
        
        newChallenge.status = ChallengeStatus.Pending
        // fill in other challenge properties for testing purpose
        
        if let duration = self.form.formRowWithTag(Tags.Duration)?.value as? XLFormOptionsObject {
            newChallenge.duration = duration.valueData() as? Int
        }
        
        if let distance = self.form.formRowWithTag(Tags.Distance)?.value as? Int {

        }
        
        newChallenge.createdBy = FirebaseManager.sharedInstance.getUserFirebaseId()
        newChallenge.member = "Friend1"
        newChallenge.startTime = NSDate().timeIntervalSince1970
        
        // saving screen loading
        FirebaseManager.sharedInstance.setChallenge(newChallenge.toDict()) { () -> Void in
            sender.enabled = true
            SVProgressHUD.dismiss()
            //dismiss loading screen
            
            //return to home
            self.performSegueWithIdentifier("UnwindToChallengeHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeOneVOneForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        Create the appropriate form base on the type and mode of the new challenge
    */
    func initializeOneVOneForm(){

        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        section = XLFormSectionDescriptor()
        detailForm.addFormSection(section)
        
        
        //type
        row = XLFormRowDescriptor(tag: Tags.ChallengeType, rowType: XLFormRowDescriptorTypeText, title: "Type:")
        row.disabled = NSNumber(bool: true)
        row.value = newChallenge.type.rawValue
        section.addFormRow(row)
        
        //mode
        row = XLFormRowDescriptor(tag: Tags.Mode, rowType: XLFormRowDescriptorTypeText, title: "Mode:")
        row.disabled = NSNumber(bool: true)
        row.value = newChallenge.mode.rawValue
        section.addFormRow(row)
        
        //title
        row = XLFormRowDescriptor(tag: Tags.Title, rowType: XLFormRowDescriptorTypeText, title: "Title:")
        row.required = true
        section.addFormRow(row)
        
    
        switch(newChallenge.mode!){
        case .Distance:
            
            row = XLFormRowDescriptor(tag :Tags.Distance, rowType:XLFormRowDescriptorTypeSelectorActionSheet, title:"Distance to run:")
            row.selectorOptions = [
                XLFormOptionsObject(value: 3, displayText: "3 km"),
                XLFormOptionsObject(value: 5, displayText:"5 km"),
                XLFormOptionsObject(value: 7, displayText:"7 km"),
                XLFormOptionsObject(value: 10, displayText:"10 km"),
                XLFormOptionsObject(value: 15, displayText:"15 km")
            ]
            row.value = XLFormOptionsObject(value: 3, displayText: "3 km")
            section.addFormRow(row)
            
            break
        case .Speed:
            break
        case .Streak:
            break
        default:
            break
        }
        
        //duration
        row = XLFormRowDescriptor(tag :Tags.Duration, rowType:XLFormRowDescriptorTypeSelectorActionSheet, title:"Days to finish challenge:")
        row.selectorOptions = [
            XLFormOptionsObject(value: 3, displayText: "3 days"),
            XLFormOptionsObject(value: 5, displayText:"5 days"),
            XLFormOptionsObject(value: 7, displayText:"7 days"),
        ]
        row.value = XLFormOptionsObject(value: 3, displayText: "3 days")
        section.addFormRow(row)
        
        
        self.form = detailForm
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
