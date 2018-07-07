//
//  PopulNhVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class PopulNhVO : Mappable {
    
    var idx : Int?
    var addr : String?
    var name : String?
    var img : String?
    var price : String?
    var period : String?
    var star : Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        idx <- map["idx"]
        addr <- map["addr"]
        name <- map["name"]
        img <- map["img"]
        price <- map["price"]
        period <- map["period"]
        star <- map["star"]
    }
}
