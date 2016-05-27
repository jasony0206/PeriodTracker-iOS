//
//  PropertyKey.swift
//  PeriodTracker
//
//  Created by Jason Yoon on 5/26/16.
//  Copyright © 2016 Jason Yoon. All rights reserved.
//

import UIKit

class ArchiveData : NSObject, NSCoding {
    // MARK: Properties
    var dates: [NSDate]
    var avgCycle: Int
    var lastPeriod: NSDate
    var nextPeriod: NSDate
    
    // MARK: Archiving paths
    static let DocumentsDirectory =
    NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("periodData")
    
    init(dates: [NSDate], avgCycle: Int, lastPeriod: NSDate, nextPeriod: NSDate) {
        self.dates = dates
        self.avgCycle = avgCycle
        self.lastPeriod = lastPeriod
        self.nextPeriod = nextPeriod
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dates, forKey: PropertyKey.datesKey)
        aCoder.encodeObject(avgCycle, forKey: PropertyKey.avgCycleKey)
        aCoder.encodeObject(lastPeriod, forKey: PropertyKey.lastPeriodKey)
        aCoder.encodeObject(nextPeriod, forKey: PropertyKey.nextPeriodKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let dates = aDecoder.decodeObjectForKey(PropertyKey.datesKey) as! [NSDate]
        let avgCycle = aDecoder.decodeObjectForKey(PropertyKey.avgCycleKey) as! Int
        let lastPeriod = aDecoder.decodeObjectForKey(PropertyKey.lastPeriodKey) as! NSDate
        let nextPeriod = aDecoder.decodeObjectForKey(PropertyKey.nextPeriodKey) as! NSDate
        self.init(dates: dates, avgCycle: avgCycle, lastPeriod: lastPeriod, nextPeriod: nextPeriod)
    }
}

struct PropertyKey {
    
    static let datesKey = "dates"
    static let avgCycleKey = "average cycle"
    static let lastPeriodKey = "last period"
    static let nextPeriodKey = "next period"
}