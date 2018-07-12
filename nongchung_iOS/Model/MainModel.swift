//
//  MainModel.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 3..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class MainModel : NetworkModel{
    
    //MARK: 비로그인
    func home(token: String) {
        
        let URL = "\(baseURL)/api/home"
        
        Alamofire.request(
            URL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["token": token]
            ).responseObject{
                (response:DataResponse<MainVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Get Information" {
                        self.view.networkResult(resultData: responseMessage, code: "Success To Get Information")
                    }
                    else if responseMessage.message == "Null Value" {
                        self.view.networkResult(resultData: "400ERR", code: "Null Value")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "500ERR", code: "Internal Server Error")
                    }
                    else if responseMessage.message == "Fail To Sign In"{
                        self.view.networkResult(resultData: "아이디 또는 패스워드를 확인해주세요.", code: "Fail To Sign In")
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
