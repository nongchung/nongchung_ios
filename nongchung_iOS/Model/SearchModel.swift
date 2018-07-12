//
//  SearchModel.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class SearchModel : NetworkModel{
    
    //MARK: 비로그인
    func searchNetworking(start: String, end: String, person: Int, scontent: String, area: [Int]) {
        
        let URL = "\(baseURL)/api/search?end=\(end)&start=\(start)&person=\(person)&scontent=\(scontent)&area=\(area)"
        let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(
            encodedUrl!,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<SearchVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Get Search" {
                        self.view.networkResult(resultData: responseMessage, code: "Success To Get Search")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "500ERR", code: "Internal Server Error")
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
