//
//  MyActivity.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct MyActivity: Codable {
    let startDate: String?
    let endDate: String?
    let addr: String?
    let period: String?
    let name: String?
    let state: Int
    let price: Int
    let currentPerson: Int
    let person: Int
    let personLimit: Int
    let idx: Int
    let img: String?
    let rState: Int?
    let rIdx: Int?
}
