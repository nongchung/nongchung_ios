//
//  FarmerService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct FarmerService : APIService {
    static func farmerInit(nhIdx: Int, completion: @escaping (FarmerInfoDataVO, [FarmerDataVO])->Void) {
        
        let URL = url("/api/home/detail/farm?idx=\(nhIdx)")
       // let token = UserDefaults.standard.string(forKey: "token")
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  nil).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let farmerData = try decoder.decode(FarmerVO.self, from: value)
                        if farmerData.message == "Success To Show Farmer Profile" {
                            completion(farmerData.farmerInfo!, farmerData.nhInfo!)
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
