//
//  PopulFarmVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class PopulFarmVO : Mappable {
    
    var farmidx : Int?
    var addr : String?
    var name : String?
    var farmImg : String?
    var farmerImg :String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        farmidx <- map["farmidx"]
        addr <- map["addr"]
        name <- map["name"]
        farmImg <- map["farmImg"]
        farmerImg <- map["farmerImg"]
    }
}
