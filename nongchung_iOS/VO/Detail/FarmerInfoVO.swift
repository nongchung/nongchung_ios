//
//  FarmerInfoVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class FarmerInfoVO : Mappable{
    
    var name : String?
    var comment : String?
    var img : String?
    var farmIdx : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        comment <- map["comment"]
        img <- map["img"]
        farmIdx <- map["farmIdx"]
    }
}
