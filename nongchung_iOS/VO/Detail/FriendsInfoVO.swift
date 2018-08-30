//
//  FriendsInfoVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class FriendsInfoVO : Mappable{
    
    var womanCount : Int?
    var manCount : Int?
    var attendCount : Int?
    var personLimit : Int?
    var ageAverage : Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        womanCount <- map["womanCount"]
        manCount <- map["manCount"]
        attendCount <- map["attendCount"]
        personLimit <- map["personLimit"]
        ageAverage <- map["ageAverage"]
    }
}
