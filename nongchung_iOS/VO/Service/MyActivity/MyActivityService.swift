//
//  MyActivityService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct MyActivityService : APIService {
    static func myActivityInit(token: String,completion: @escaping (MyActivityTotal, [MyActivity])->Void) {
        let URL = url("/api/activity")
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    do {
                        let aaa = try decoder.decode(MyActivityData.self, from: value)
                        
                        if aaa.message == "success to show activity" {
                            completion(aaa.total!, aaa.data!)
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                        
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
