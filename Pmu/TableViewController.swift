//
//  TableViewController.swift
//  Pmu
//
//  Created by seohuibaek on 2023/07/29.
//

import UIKit

class TableViewController: UITableViewController {

    var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6","Item 7","Item 8", "Item 9"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //navigationBar bottom bolder line 제거하기
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //navigationController?.isToolbarHidden = true
        
        // 빈 뷰를 생성하여 tableFooterView로 설정
        //let emptyFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        //tableView.tableFooterView = emptyFooterView
    }
    

       // MARK: - UITableViewDataSource

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return data.count
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell", for: indexPath)
           cell.textLabel?.text = data[indexPath.row]
           return cell
       }
       
       // MARK: - UITableViewDelegate
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // 선택한 셀에 대한 동작을 정의
       }
       
       // 새로운 셀을 추가하는 메서드
       func addNewItem() {
           data.append("New Item")
           let indexPath = IndexPath(row: data.count - 1, section: 0)
           tableView.insertRows(at: [indexPath], with: .automatic)
       }

}
