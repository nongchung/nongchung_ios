//
//  NhInfoVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class NhInfoVO : Mappable{
    
    var nhIdx : String?
    var addr : String?
    var name : String?
    var star : Double?
    var description : String?
    var price : Int?
    var period : String?
    var isBooked : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        nhIdx <- map["nhIdx"]
        addr <- map["addr"]
        name <- map["name"]
        star <- map["star"]
        description <- map["description"]
        price <- map["price"]
        period <- map["period"]
        isBooked <- map["isBooked"]
    }
}
