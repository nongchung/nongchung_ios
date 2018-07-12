//
//  Utility.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

class Utility {
    
    static var calendar: Calendar {
        get {
            var c = Calendar.current
            c.timeZone = TimeZone(abbreviation: "GMT")!
            return c
        }
    }
}
