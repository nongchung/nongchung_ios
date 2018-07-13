//
//  AllStartDateVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class AllStartDateVO : Mappable{
    
    var idx : Int?
    var state : Int?
    var startDate : String?
    var endDate : String?
    var availPerson  : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        idx <- map["idx"]
        state <- map["state"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        availPerson <- map["availPerson"]
    }
}
