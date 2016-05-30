//
//  ProfileTableViewController.swift
//  PeriodTracker
//
//  Created by Jason Yoon on 5/29/16.
//  Copyright © 2016 Jason Yoon. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, ChangeMemberDelegate {

    // MARK: Properties
    var dates = [NSDate]()
    var avgCycle = 28
    var lastPeriod: NSDate = NSDate()
    var nextPeriod: NSDate = NSDate()
    @IBOutlet weak var avgCycleLabel: UILabel!
    @IBOutlet weak var lastPeriodLabel: UILabel!
    @IBOutlet weak var nextPeriodLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.redColor();
        
        // Load any saved data, otherwise properly initialize
        if let savedData = loadData() {
            self.dates = savedData.dates
            self.avgCycle = savedData.avgCycle
            self.lastPeriod = savedData.lastPeriod
            self.nextPeriod = savedData.nextPeriod
            updateProfile()
        } else {
            resetData()
        }
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
            let detailVC = segue.destinationViewController as! PeriodTableViewController
            detailVC.delegate = self
            detailVC.dates = self.dates
        }
    }
    
    func updateProfile() {
        if dates.count >= 1 {
            dates.sortInPlace({ $0.compare($1) == NSComparisonResult.OrderedDescending })
            
            // Update last period
            lastPeriod = dates[0]
            lastPeriodLabel.text = dateToString(lastPeriod)
            
            // Update average cycle
            if dates.count == 1 {
                avgCycle = 28
            } else if dates.count >= 2 {
                var sum = 0
                for i in 0..<(dates.count - 1) {
                    let cycleLength = dates[i + 1].numberOfDaysUntilDateTime(dates[i])
                    sum += cycleLength
                }
                avgCycle = sum / (dates.count - 1)
            }
            avgCycleLabel.text = "\(avgCycle) days"
            
            // Update next period
            nextPeriod = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: avgCycle,
                toDate: lastPeriod,
                options: NSCalendarOptions(rawValue: 0))!
            nextPeriodLabel.text = "\(nextPeriod.dayOfWeekStr()) " + dateToString(nextPeriod)
            
            // Update countdown
            let numDaysTillNextPeriod = NSDate().numberOfDaysUntilDateTime(nextPeriod)
            countdownLabel.text = "\(numDaysTillNextPeriod) days until next period..."
            print("updated countdown: \(numDaysTillNextPeriod)")
        } else {
            resetData()
        }
        saveData()
    }
    
    func resetData() {
        avgCycle = 28
        lastPeriodLabel.text = "?"
        avgCycleLabel.text = "\(avgCycle) days"
        nextPeriodLabel.text = "?"
        countdownLabel.text = "? days until next period..."
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
    
    // MARK: NSCoding
    func saveData() {
        let data = ArchivePeriodData(dates: dates, avgCycle: avgCycle, lastPeriod: lastPeriod, nextPeriod: nextPeriod)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: ArchivePeriodData.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save period data...")
        }
    }
    
    func loadData() -> ArchivePeriodData? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(ArchivePeriodData.ArchiveURL.path!) as? ArchivePeriodData
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
    
    func dayOfWeekStr() -> String {
        let dayOfWeek = self.dayOfWeek()!
        switch dayOfWeek {
        case 1: return "Sun"
        case 2: return "Mon"
        case 3: return "Tue"
        case 4: return "Wed"
        case 5: return "Thu"
        case 6: return "Fri"
        case 7: return "Sat"
        default: return ""
        }
    }
    
    func dayOfWeek() -> Int? {
        if
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) {
                return comp.weekday
        } else {
            return nil
        }
    }
}