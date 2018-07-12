//
//  SearchVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class SearchVO : Mappable {
    
    var message : String?
    var data : [SearchDataVO]?

    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        data <- map["data"]
    }
}
