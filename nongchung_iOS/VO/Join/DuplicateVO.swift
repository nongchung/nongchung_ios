//
//  DuplicateVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class DuplicateVO : Mappable{
    
    var message : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
    }
}
