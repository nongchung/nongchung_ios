//
//  FarmerDataVO.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct FarmerDataVO: Codable {
    let nhName: String?
    let farmAddr: String?
    let period: String?
    let price: Int?
    let nhIdx: Int?
    let farmIdx: Int?
    let newState: Int?
    let farmImg: String?
    let isBooked: Int?
}
