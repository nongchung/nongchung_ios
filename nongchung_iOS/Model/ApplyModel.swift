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
    
    func applyNetworking(nhIdx: Int, schIdx: Int, token: String) {
        
        let URL = "\(baseURL)/api/home/request"
        
        let body : [String : Any] = [
            "nhIdx" : nhIdx,
            "schIdx" : schIdx
        ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: ["token": token]
            ).responseObject{
                (response:DataResponse<ApplyVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    if responseMessage.message == "Success To Request For Application" {
                        self.view.networkResult(resultData: responseMessage, code: "Success To Request For Application")
                    }
                    else if responseMessage.message == "No token"{
                        self.view.networkResult(resultData: "토큰 없을때", code: "No token")
                    }
                    else if responseMessage.message == "Null Value"{
                        self.view.networkResult(resultData: "농활인덱스, 스케쥴 인덱스 없을 때", code: "Null Value")
                    }
                    else if responseMessage.message == "Invalid nhIdx and schIdx"{
                        self.view.networkResult(resultData: "이상한 농활인덱스, 스케쥴 인덱스일때", code: "Invalid nhIdx and schIdx")
                    }
                    else if responseMessage.message == "Invalid schIdx"{
                        self.view.networkResult(resultData: "신청불가능한 스케쥴일 때", code: "Invalid schIdx")
                    }
                    else if responseMessage.message == "Duplicate To Time"{
                        self.view.networkResult(resultData: "이미 신청한 시간대에 또 신청했을 때", code: "Duplicate To Time")
                    }
                    else if responseMessage.message == "Fail To Request For Application, No Available Person Number"{
                        self.view.networkResult(resultData: "여석이 없을 때", code: "Fail To Request For Application, No Available Person Number")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "서버에러", code: "Internal Server Error")
                    }
                    
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
    
    func applyCancelNetworking(nhIdx: Int, schIdx: Int, token: String) {
        
        let URL = "\(baseURL)/api/home/request"
        
        let body : [String : Any] = [
            "nhIdx" : nhIdx,
            "schIdx" : schIdx
        ]
        
        Alamofire.request(
            URL,
            method: .put,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: ["token": token]
            ).responseObject{
                (response:DataResponse<ApplyVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    
                    if responseMessage.message == "Success To Cancel" {
                        self.view.networkResult(resultData: responseMessage, code: "Success To Cancel")
                    }
                    else if responseMessage.message == "No token"{
                        self.view.networkResult(resultData: "토큰 없을때", code: "No token")
                    }
                    else if responseMessage.message == "Null Value"{
                        self.view.networkResult(resultData: "농활인덱스, 스케쥴 인덱스 없을 때", code: "Null Value")
                    }
                    else if responseMessage.message == "Internal Server Error"{
                        self.view.networkResult(resultData: "서버에러", code: "Internal Server Error")
                    }
                    
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
