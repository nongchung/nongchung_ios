//
//  NoticeTableViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 5..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import UIKit

class NoticeTableViewController: UITableViewController {
    private func getData() -> [NoticeData?] {
        var data: [NoticeData?] = []
        
        let first_content = [ContentData(content: "content")]
        let first = NoticeData(title: "슈퍼슈퍼 업데이트", contents: first_content)
        
        let second_content = [ContentData(content: "우리 농촌 활동 함께해요 특집이 게시되었습니다.\n특집은 농활참여자들이 학생일 경우 10%할인 됩니다.\n많은 관심 부탁드립니다.\n*특집 농활*\n1.우도환 완전 좋아좋아 짱이야 농장\n2.서강준 짱멋져 농장\n3.박서준이 최고지 농장")]
        let second = NoticeData(title: "우리 농촌활동 해요 (특집)", contents: second_content)
        
        let third_content = [ContentData(content: "content")]
        let third = NoticeData(title: "업데이트 8.8", contents: third_content)
        
        let fourth_content = [ContentData(content: "content")]
        let fourth = NoticeData(title: "새로운 농촌활동 3가지 공지해드립니다.", contents: fourth_content)
        
        let fifth_content = [ContentData(content: "취소는 상세페이지의 환불규정내역을 확인해주세요")]
        let fifth = NoticeData(title: "농촌활동 신청시 취소 공지사항", contents: fifth_content)

        
        return [first, second, third, fourth, fifth]
    }
    
    var noticeData: [NoticeData?]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.title = "공지사항"
        
        noticeData = getData()
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: NoticeData?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = noticeData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        if let contents = noticeData?[index]?.contents {
            for i in 1...contents.count {
                noticeData?.insert(nil, at: index + i)
                tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        if let contents = noticeData?[index]?.contents {
            for i in 1...contents.count {
                noticeData?.remove(at: index+1)
                tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
                
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = noticeData {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        if let rowData = noticeData?[indexPath.row] {
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as! NoticeTableViewCell
            defaultCell.noticeLabel.text = rowData.title
            defaultCell.selectionStyle = .none
            
            return defaultCell
        }
            // Row is ExpansionCell
        else {
            if let rowData = noticeData?[getParentCellIndex(expansionIndex: indexPath.row)] {
                // Create an ExpansionCell
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "NoticeExpansionTableViewCell", for: indexPath) as! NoticeExpansionTableViewCell
                
                // Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
                // Get the index of the flight data (e.g. if there are multiple ExpansionCells
                let contentIndex = indexPath.row - parentCellIndex - 1
                
                // Set the cell's data
                expansionCell.textView.text = rowData.contents?[contentIndex].content
                
                expansionCell.selectionStyle = .none
                
                return expansionCell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let rowData = noticeData?[indexPath.row] {
            return 50
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = noticeData?[indexPath.row] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(indexPath.row + 1 >= (noticeData?.count)!) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(noticeData?[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                    // Close Cell (remove ExpansionCells)
                } else {
                    contractCell(tableView: tableView, index: indexPath.row)
                    
                }
            }
        }
    }

}
