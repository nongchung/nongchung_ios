//
//  TabBarController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 2..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBar tint 값 제거 및 이미지 적용
        //UITabBar.appearance().barTintColor = UIColor.init()
        let tabBar = self.tabBar
        let homeImage = UIImage(named:"ic_tapbar_home1")?.withRenderingMode(.alwaysOriginal)
        let searchImage = UIImage(named: "ic_tapbar_search1")?.withRenderingMode(.alwaysOriginal)
        let myActivityImage = UIImage(named: "ic_tapbar_mylog1")?.withRenderingMode(.alwaysOriginal)
        let jjimImage = UIImage(named: "ic_tapbar_myzzim1")?.withRenderingMode(.alwaysOriginal)
        
        let moreImage = UIImage(named: "ic_tapbar_more1")?.withRenderingMode(.alwaysOriginal)
        
        (tabBar.items![0] ).selectedImage = homeImage
        (tabBar.items![1] ).selectedImage = searchImage
        (tabBar.items![2] ).selectedImage = myActivityImage
        (tabBar.items![3] ).selectedImage = jjimImage
        (tabBar.items![4] ).selectedImage = moreImage
        
    }

}
