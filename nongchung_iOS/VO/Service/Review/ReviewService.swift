//
//  ReviewService.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 8..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct ReviewService: APIService {
    //MARK: 농활 상세보기 - 리뷰
    static func reviewInit(scheIdx: Int, completion: @escaping ([ReviewDataVO])->Void) {
        print("리뷰 서비스 들어감")
        let URL = url("/api/review?nhIdx=\(scheIdx)")
        //let token = UserDefaults.standard.string(forKey: "token")
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    do {
                        print("리뷰 두들어옴")
                        let reviewData = try decoder.decode(ReviewVO.self, from: value)
                        print(reviewData)
                        if reviewData.message == "Success to Get Review List" {
                            print("리뷰성공")
                            completion(reviewData.rvListInfo!)
                        } else if reviewData.message == "No Reviews" {
                            print("리뷰없거든")
                        }
                    } catch {
                        print("리뷰 캐치문")
                    }
                    //////////////////
                }
                
                break
            case .failure(let err):
                print("리뷰 실패요")
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //MARK: 더보기 - 내후기 리뷰
    static func myReviewInit(completion: @escaping ([MyReviewDataVO])->Void) {
        let URL = url("/api/mypage/myreview")
        let token = UserDefaults.standard.string(forKey: "token")
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token!]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let reviewData = try decoder.decode(MyReviewVO.self, from: value)
                        
                        if reviewData.message == "success To show review" {
                            completion(reviewData.data)
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
    
    //MARK: 내 활동 - 리뷰 작성하기
    static func writeImageReview(rImages: [UIImage], content: String,
                                 scheIdx: String, star: String, completion: @escaping ()->Void) {
        print("들어와라라라라")
        let URL = url("/api/review")
        let userdefault = UserDefaults.standard
        guard let token = userdefault.string(forKey: "token") else { return }
        
        let content = content.data(using: .utf8)
        let scheIdx = scheIdx.data(using: .utf8)
        let star = star.data(using: .utf8)
        
        var imageData = [UIImage]()
        for i in 0..<rImages.count {
            imageData.append(rImages[i])
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for i in 0..<rImages.count {
                let image = UIImageJPEGRepresentation(imageData[i], 0.3)
                multipartFormData.append(image!, withName: "rImages", fileName: "photo.jpg", mimeType: "image/jpeg")
            }
            multipartFormData.append(content!, withName: "content")
            multipartFormData.append(scheIdx!, withName: "scheIdx")
            multipartFormData.append(star!, withName: "star")
        }, to: URL, method: .post, headers: ["token" : token])
        { (encodingResult) in
            switch encodingResult {
                
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseData( completionHandler: { (res) in
                    switch res.result{
                    case .success:
                        if let value = res.result.value {
                            let message = JSON(value)["mesaage"].string
                            
                            if message == "Success to Review"{
                                completion()
                            }
                        }
                        break
                        
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                    
                })
                
            case .failure(let err):
                print(err.localizedDescription)
                
            }
        }
    }
    
    //MARK: 농활 상세보기 - 리뷰 수정 시 받아오는 내용
    static func reviewEditInit(scheIdx: Int, completion: @escaping (ReviewEditDataVO)->Void) {
        let URL = url("/api/activity/review/\(scheIdx)")
        let token = UserDefaults.standard.string(forKey: "token")
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["token" : token!]).responseData() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    
                    do {
                        let reviewData = try decoder.decode(ReviewEditVO.self, from: value)
                        
                        if reviewData.message == "Sucess To show review INFO" {
                            completion(reviewData.data)
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
