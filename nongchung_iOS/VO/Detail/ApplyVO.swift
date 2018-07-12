//
//  ApplyVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 9..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class ApplyVO : Mappable{
    
    var message : String?
    var maxPerson : Int?
    var currentPerson : Int?
    var myScheduleActivities : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        maxPerson <- map["maxPerson"]
        currentPerson <- map["currentPerson"]
        myScheduleActivities <- map["myScheduleActivities"]
    }
}
