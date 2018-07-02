//
//  APIService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation

protocol APIService {
    
}

extension APIService {
    static func url(_ path: String) -> String {
        return "http://13.125.216.198:3000" + path
    }
}
