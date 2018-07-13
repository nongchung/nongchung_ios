//
//  FarmerVO.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct FarmerVO: Codable {
    let message: String?
    let farmerInfo: FarmerInfoDataVO?
    let nhInfo: [FarmerDataVO]?
}
