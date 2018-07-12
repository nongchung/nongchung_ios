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
        var tabBar = self.tabBar
        var homeImage = UIImage(named:"ic_tapbar_home1")?.withRenderingMode(.alwaysOriginal)
        var searchImage = UIImage(named: "ic_tapbar_search1")?.withRenderingMode(.alwaysOriginal)
        var myActivityImage = UIImage(named: "ic_tapbar_mylog1")?.withRenderingMode(.alwaysOriginal)
        var jjimImage = UIImage(named: "ic_tapbar_myzzim1")?.withRenderingMode(.alwaysOriginal)
        
        var moreImage = UIImage(named: "ic_tapbar_more1")?.withRenderingMode(.alwaysOriginal)
        
        (tabBar.items![0] as! UITabBarItem).selectedImage = homeImage
        (tabBar.items![1] as! UITabBarItem).selectedImage = searchImage
        (tabBar.items![2] as! UITabBarItem).selectedImage = myActivityImage
        (tabBar.items![3] as! UITabBarItem).selectedImage = jjimImage
        (tabBar.items![4] as! UITabBarItem).selectedImage = moreImage
        
    }

}
