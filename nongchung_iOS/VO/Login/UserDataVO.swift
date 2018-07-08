//
//  UserDataVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class UserDataVO : Mappable {
    var mail : String?
    var name : String?
    var birth : String?
    var sex : Int?
    var hp : String?
    var point : Int?
    var img : String?
    var nickname : String?
    var age : Int?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        mail <- map["mail"]
        name <- map["name"]
        birth <- map["birth"]
        sex <- map["sex"]
        hp <- map["hp"]
        point <- map["point"]
        img <- map["img"]
        nickname <- map["nickname"]
        age <- map["age"]
    }
}
