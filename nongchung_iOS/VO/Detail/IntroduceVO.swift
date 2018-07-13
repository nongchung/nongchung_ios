//
//  IntroduceVO.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import ObjectMapper

class IntroduceVO : Mappable{
    
    var message : String?
    var image : [String]?
    var nhInfo : NhInfoVO?
    var friendsInfo : [FriendsInfoVO]?
    var farmerInfo : FarmerInfoVO?
    var schedule : [ScheduleVO]?
    var nearestStartDate : String?
    var nearestEndDate : String?
    var allStartDate : [AllStartDateVO]?
    var myScheduleActivities : [Int]?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        image <- map["image"]
        nhInfo <- map["nhInfo"]
        friendsInfo <- map["friendsInfo"]
        farmerInfo <- map["farmerInfo"]
        schedule <- map["schedule"]
        nearestStartDate <- map["nearestStartDate"]
        nearestEndDate <- map["nearestEndDate"]
        allStartDate <- map["allStartDate"]
        myScheduleActivities <- map["myScheduleActivities"]
    }
}
