//
//  ViewController.swift
//  PeriodTracker
//
//  Created by Jason Yoon on 5/23/16.
//  Copyright © 2016 Jason Yoon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ChangeMemberDelegate {
    
    // MARK: Properties
    var dates = [NSDate]()
    @IBOutlet weak var avgCycleLabel: UILabel!
    @IBOutlet weak var lastPeriodLabel: UILabel!
    @IBOutlet weak var nextPeriodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.redColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddPeriodViewController,
        newDate: NSDate = sourceViewController.pickedDate as NSDate {
            dates.append(newDate)
            updateProfile()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "DateListSegue") {
            let detailVC = segue.destinationViewController as! PeriodTableViewController;
            detailVC.delegate = self
            detailVC.dates = self.dates
        }
    }
    
    func updateProfile() {
        if dates.count >= 1 {
            dates.sortInPlace({ $0.compare($1) == NSComparisonResult.OrderedDescending })
            
            // Update last period
            let lastPeriodDate = dates[0]
            lastPeriodLabel.text = dateToString(lastPeriodDate)
            
            // Update average cycle
            var avgCycleLength = 28
            if dates.count >= 2 {
                var sum = 0
                for i in 0..<(dates.count - 1) {
                    let cycleLength = dates[i + 1].numberOfDaysUntilDateTime(dates[i])
                    sum += cycleLength
                }
                avgCycleLength = sum / (dates.count - 1)
            }
            avgCycleLabel.text = "\(avgCycleLength) days"
            
            // Update next period
            let nextPeriodDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: avgCycleLength,
                toDate: lastPeriodDate,
                options: NSCalendarOptions(rawValue: 0))
            nextPeriodLabel.text = dateToString(nextPeriodDate!)
        } else {
            lastPeriodLabel.text = "?"
            avgCycleLabel.text = "28 days"
            nextPeriodLabel.text = "?"
        }
    }
    
    func updateDates(viewController: PeriodTableViewController, updatedDates: [NSDate]) {
        self.dates = updatedDates
        updateProfile()
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
}

extension NSDate {
    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
}

