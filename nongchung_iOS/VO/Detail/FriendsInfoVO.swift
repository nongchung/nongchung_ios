//
//  FriendsInfoVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 6..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class FriendsInfoVO : Mappable{
    
    var name : String?
    var nickname : String?
    var img : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        nickname <- map["nickname"]
        img <- map["img"]
    }
}
