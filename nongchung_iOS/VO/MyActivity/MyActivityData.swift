//
//  MyActivityData.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

struct MyActivityData: Decodable {
    let message: String?
    let total: [MyActivityTotal]?
    let data: [MyActivity]?
}
