//
//  AdsVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class AdsVO : Mappable {
    
    var title : String?
    var description : String?
    var type : Int?
    var img : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        img <- map["img"]
        description <- map["description"]
        type <- map["type"]
    }
}
