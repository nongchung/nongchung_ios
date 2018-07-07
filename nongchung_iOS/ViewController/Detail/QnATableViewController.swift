//
//  QnATableViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 4..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class QnATableViewController: UIViewController {
    
    @IBOutlet var customTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTableView.delegate = self
        customTableView.dataSource = self
    }
    
}

extension QnATableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

}

extension QnATableViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        //Scrollview in child controllers
        return customTableView
    }
}

