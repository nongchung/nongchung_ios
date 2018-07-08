//
//  ApplyModel.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class ApplyModel : NetworkModel{
    
    func applyNetworking(idx: Int) {
        
        let URL = "\(baseURL)/api/home/detail/nh?idx=\(idx)"
        
        Alamofire.request(
            URL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<IntroduceVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Get Detail Information" {
                        self.view.networkResult(resultData: responseMessage, code: "Success To Get Detail Information")
                    }
                    else if responseMessage.message == "Null Value" {
                        self.view.networkResult(resultData: "400ERR", code: "Null Value")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "500ERR", code: "Internal Server Error")
                    }
                    else if responseMessage.message == "No nonghwal activity"{
                        self.view.networkResult(resultData: "정당한 농활이 아님.", code: "No nonghwal activity")
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
