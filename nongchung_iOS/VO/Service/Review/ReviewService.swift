//
//  ReviewService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct ReviewService: APIService {
    static func reviewInit(completion: @escaping ([ReviewDataVO])->Void) {
        let URL = url("/api/mypage/myreview")
        let token = UserDefaults.standard.string(forKey: "token")
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token!]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let reviewData = try decoder.decode(ReviewVO.self, from: value)
                        
                        if reviewData.message == "success To show review" {
                            completion(reviewData.data)
                        }
                    } catch {
                        
                    }
                    //////////////////
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    
}
