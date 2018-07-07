//
//  MainVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class MainVO : Mappable {
    
    var message : String?
    var ads : [AdsVO]?
    var populNh : [PopulNhVO]?
    var newNh : [NewNhVO]?
    var populFarm : [PopulFarmVO]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        ads <- map["ads"]
        populNh <- map["populNh"]
        newNh <- map["newNh"]
        populFarm <- map["populFarm"]
    }
}
