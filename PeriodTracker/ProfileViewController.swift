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
    @IBOutlet weak var avgCycle: UILabel!
    @IBOutlet weak var lastPeriod: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.redColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddPeriodViewController,
        newDate: NSDate = sourceViewController.pickedDate as NSDate {
            dates.append(newDate)
            dates.sortInPlace({ $0.compare($1) == NSComparisonResult.OrderedDescending })
            lastPeriod.text = dateToString(dates[0])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "dateListSegue") {
            let detailVC = segue.destinationViewController as! PeriodTableViewController;
            detailVC.dates = self.dates
        }
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
}

