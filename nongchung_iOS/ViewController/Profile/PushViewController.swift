//
//  PushViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    @IBOutlet weak var pushTableView: UITableView!
    
    var push = ["푸쉬알림설정", "알림음"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "푸쉬알림"

        
        pushTableView.delegate = self
        pushTableView.dataSource = self
      
    }

}

extension PushViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return push.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PushTableViewCell", for: indexPath) as! PushTableViewCell
        
        cell.pushLabel.text = push[indexPath.row]
        
        return cell
    }
    

}
