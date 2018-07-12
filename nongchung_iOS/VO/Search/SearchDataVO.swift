//
//  SearchDataVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class SearchDataVO : Mappable {
    
    
    var idx : Int?
    var name : String?
    var price : Int?
    var star : Int?
    var period : String?
    var img : String?
    var addrIdx : Int?
    var addr : String?
    var isBooked : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        idx <- map["idx"]
        name <- map["name"]
        price <- map["price"]
        addrIdx <- map["addrIdx"]
        addr <- map["addr"]
        star <- map["star"]
        period <- map["period"]
        img <- map["img"]
        isBooked <- map["isBooked"]
    }

}
