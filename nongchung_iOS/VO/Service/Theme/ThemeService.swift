//
//  ThemeService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct ThemeService : APIService {
    static func themeInit(themeIdx: Int, completion: @escaping ([ThemeDataVO])->Void) {
        let URL = url("/api/home/theme/\(themeIdx)")
        //let token = UserDefaults.standard.string(forKey: "token")
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let themeData = try decoder.decode(ThemeVO.self, from: value)
                        
                        if themeData.message == "Success To show themeList" {
                            completion(themeData.data)
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
