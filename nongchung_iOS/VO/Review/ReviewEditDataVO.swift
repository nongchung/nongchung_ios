//
//  ReviewEditDataVO.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct ReviewEditDataVO: Codable {
    let content: String?
    let star: Double?
    let img: [String]?
    let rIdx: Int?
}
