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
        
        let first_content = [AnswerData(content: "content")]
        let first = QnAData(title: "여기 농장주가 진짜 아이돌 차은우씨인가요??", contents: first_content)
        
        let second_content = [AnswerData(content: "우리 농촌 활동 함께해요 특집이 게시되었습니다.\n특집은 농활참여자들이 학생일 경우 10%할인 됩니다. 많은 관심 부탁드립니다.\n*특집 농활*\n1.우도환 완전 좋아좋아 짱이야 농장\n2.서강준 짱멋져 농장\n3.박서준이 최고지 농장")]
        let second = QnAData(title: "환불은 어떻게 되나요", contents: second_content)
        
        let third_content = [AnswerData(content: "content")]
        let third = QnAData(title: "결제가 되지 않아요", contents: third_content)
        
        let fourth_content = [AnswerData(content: "content")]
        let fourth = QnAData(title: "서리해도 되나요?", contents: fourth_content)
        
        let fifth_content = [AnswerData(content: "취소는 상세페이지의 환불규정내역을 확인해주세요")]
        let fifth = QnAData(title: "농촌활동 신청시 취소 공지사항", contents: fifth_content)
        
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
        if indexPath.section == 0 {
            if let rowData = qnaData?[indexPath.row] {
                return 50
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            return UITableViewAutomaticDimension
        }
   
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
