//
//  ViewController.swift
//  PeriodTracker
//
//  Created by Jason Yoon on 5/23/16.
//  Copyright © 2016 Jason Yoon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    var dates = [NSDate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.view.backgroundColor = UIColor.redColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddPeriodViewController,
            newDate: NSDate = sourceViewController.date as NSDate {
            dates.append(newDate)
        }
    }
}

