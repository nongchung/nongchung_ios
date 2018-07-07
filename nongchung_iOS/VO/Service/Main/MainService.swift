//
//  MainService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 1..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct MainService : APIService {
    static func mainInit(completion: @escaping ([MainAds], [Main])->Void) {
        let URL = url("/api/home")
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
            case .success:
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let mainData = try decoder.decode(MainData.self, from: value)
                        
                        completion(mainData.ads, mainData.data)
                        
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
