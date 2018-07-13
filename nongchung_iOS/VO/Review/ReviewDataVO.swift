//
//  ReviewDataVO.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct ReviewDataVO: Codable {
    let uimg: String?
    let name: String?
    let startDate: String?
    let star: Double?
    let content: String?
    let rvImages: [String]?
}
