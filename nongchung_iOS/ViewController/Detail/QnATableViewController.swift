//
//  QnATableViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 10..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import Foundation
import UIKit

class QnATableViewController: UITableViewController {
    private func getData() -> [QnAData?] {
        var data: [QnAData?] = []
        
        let first_content = [AnswerData(content: "그 경우에는 강수량을 고려하여, 농활 성사 여부를 판단합니다.")]
        let first = QnAData(title: "우천시 농활을 신청했을 경우에는 어떻게 되나요?", contents: first_content)
        
        let second_content = [AnswerData(content: "일 잘하고 성실한 사람을 원하고 있습니다.")]
        let second = QnAData(title: "농장에서 특별히 원하는 사람이 있나요?", contents: second_content)
        
        let third_content = [AnswerData(content: "아니요! 농장은 저희측에서 버스를 통해 일괄적으로 태워서 데려다 드립니다.")]
        let third = QnAData(title: "농장이 너무 먼데 직접 찾아가야하나요?", contents: third_content)
        
        let fourth_content = [AnswerData(content: "아닙니다. 가져가실 수 없습니다. 다만, 몇몇 농장의 경우 연계 판매 서비스를 제공하고 있습니다.")]
        let fourth = QnAData(title: "농장에서 수확한 과일이나 채소는 직접 가져 갈 수 있나요?", contents: fourth_content)
        
        let fifth_content = [AnswerData(content: "봉사활동 시간의 경우, 해당 센터에서 승인을 할 때까지 3~4일이 걸리므로, 승인 후 푸시메시지로 알림을 드립니다.")]
        let fifth = QnAData(title: "농활을 다녀온 후 봉사활동 시간은 어떻게 발급받나요?", contents: fifth_content)
        
        return [first, second, third, fourth, fifth]
    }
    
    var qnaData: [QnAData?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        qnaData = getData()
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: QnAData?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = qnaData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        if let contents = qnaData?[index]?.contents {
            for i in 1...contents.count {
                qnaData?.insert(nil, at: index + i)
                tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        if let contents = qnaData?[index]?.contents {
            for i in 1...contents.count {
                qnaData?.remove(at: index+1)
                tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
                
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let data = qnaData {
                return data.count
            } else {
                return 0
            }
        } else {
            return 1
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let rowData = qnaData?[indexPath.row] {
                let defaultCell = tableView.dequeueReusableCell(withIdentifier: "QnATableViewCell", for: indexPath) as! QnATableViewCell
                
                defaultCell.questionLabel.text = rowData.title
                defaultCell.selectionStyle = .none
                
                return defaultCell
            } else {
                if let rowData = qnaData?[getParentCellIndex(expansionIndex: indexPath.row)] {
                    // Create an ExpansionCell
                    let expansionCell = tableView.dequeueReusableCell(withIdentifier: "QnAExpansionTableViewCell", for: indexPath) as! QnAExpansionTableViewCell
                    
                    // Get the index of the parent Cell (containing the data)
                    let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                    
                    // Get the index of the flight data (e.g. if there are multiple ExpansionCells
                    let contentIndex = indexPath.row - parentCellIndex - 1
                    
                    // Set the cell's data
                    expansionCell.answerLabel.text = rowData.contents?[contentIndex].content
                    
                    expansionCell.selectionStyle = .none
                    
                    return expansionCell
                }
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QnALastTableViewCell", for: indexPath) as! QnALastTableViewCell
            
            cell.label.text = "*더 자세한 문의를 원한다면\n010 0000 (농활청춘 담당자)로 연락해주세요!"
            cell.selectionStyle = .none
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            if let rowData = qnaData?[indexPath.row] {
//                return 50
//            } else {
//                return UITableViewAutomaticDimension
//            }
//        } else {
//            return UITableViewAutomaticDimension
//        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let data = qnaData?[indexPath.row] {
                // If user clicked last cell, do not try to access cell+1 (out of range)
                if(indexPath.row + 1 >= (qnaData?.count)!) {
                    expandCell(tableView: tableView, index: indexPath.row)
                }
                else {
                    // If next cell is not nil, then cell is not expanded
                    if(qnaData?[indexPath.row+1] != nil) {
                        expandCell(tableView: tableView, index: indexPath.row)
                        // Close Cell (remove ExpansionCells)
                    } else {
                        contractCell(tableView: tableView, index: indexPath.row)
                        
                    }
                }
            }
        } else {
            
        }

    }
    
}
