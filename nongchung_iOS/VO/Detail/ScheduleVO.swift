//
//  ScheduleVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class ScheduleVO : Mappable{
    var time : String?
    var activity : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        time <- map["time"]
        activity <- map["activity"]
    }
}
