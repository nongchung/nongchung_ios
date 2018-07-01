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
//    static func boardInit(completion: @escaping ([Board])->Void) {
//        print(1111)
//        let URL = url("/board")
//        
//        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
//            print(333333)
//            switch res.result {
//            case .success:
//                if let value = res.result.value {
//                    print(444)
//                    
//                    //                    //////// SwiftyJSON : 뭐가 나오는지 확인해주세요 /////////
//                    //                    print(JSON(value)["data"][0]["board_content"].string)
//                    //                    //////////////////
//                    //
//                    
//                    
//                    //////// Codable /////////
//                    let decoder = JSONDecoder()
//                    
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    
//                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
//                    
//                    do {
//                        let boardData = try decoder.decode(BoardData.self, from: value)
//                        
//                        if boardData.message == "Successful Get Board Data" {
//                            print(22222)
//                            //                            self.boards = boardData.data
//                            //                            self.tableView.reloadData()
//                            
//                            completion(boardData.data)
//                        }
//                        
//                    } catch {
//                        
//                    }
//                    //////////////////
//                }
//                
//                break
//            case .failure(let err):
//                print(err.localizedDescription)
//                break
//            }
//        }
//    }
    
    
    
}
