//
//  APNSModel.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 12..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class APNSModel : NetworkModel{
    
    //MARK: 비로그인
    func apnsTokenNetworking(deviceCategoty: Int, token: String) {
        
        let URL = "\(baseURL)/api/push"
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<APNsVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Register Token" {
                        self.view.networkResult(resultData: responseMessage, code: "Success To Register Token")
                    }
                    else if responseMessage.message == "token error"{
                        self.view.networkResult(resultData: "tokenError", code: "token error")
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
