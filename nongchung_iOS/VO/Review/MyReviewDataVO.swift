//
//  MyReviewDataVO.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct MyReviewDataVO: Codable {
    let img: [String]
    let name: String?
    let content: String?
    let star: Int?
    let startDate: String?
}
