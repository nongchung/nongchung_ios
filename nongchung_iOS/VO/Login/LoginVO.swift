//
//  LoginVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class LoginVO : Mappable {
    var message : String?
    var token : String?
    var data : [UserDataVO]?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        message <- map["message"]
        token <- map["token"]
        data <- map["data"]
    }
}
