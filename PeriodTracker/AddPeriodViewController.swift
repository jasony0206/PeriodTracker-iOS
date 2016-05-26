//
//  AddPeriodViewController.swift
//  PeriodTracker
//
//  Created by Jason Yoon on 5/25/16.
//  Copyright © 2016 Jason Yoon. All rights reserved.
//

import UIKit

class AddPeriodViewController: UIViewController {
    
    // MARK: Properties
    var date: NSDate = NSDate()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === saveButton {
            date = datePicker.date
        }
    }
}
