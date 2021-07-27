//
//  SettingsTableTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/08.
//

import UIKit

class SettingsTableViewController: UITableViewController {

//    let cellNameList = ["애플워치 연동", "알림 설정", "도움말"]
//    let cellImageList = ["applewatch", "alarm", "questionmark.circle"]
    
    let cellNameList = ["알림 설정"]
    let cellImageList = ["alarm"]
    
    struct CellNameImagePair {
        static let alarmCell: (name: String, identifier: String) = ("알림 설정", "alarm")
        
        static let cellList = [alarmCell]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barStyle = .black
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellNameImagePair.cellList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        
        cell.settingsImageView.image = UIImage(systemName: CellNameImagePair.cellList[indexPath.row].identifier)
        cell.settingsImageView.tintColor = UIColor(red: 25/255, green: 63/255, blue: 110/255, alpha: 1)
        cell.settingsImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: CGFloat(25.0))
        
        let attributedNameString = NSMutableAttributedString()
            .normal(CellNameImagePair.cellList[indexPath.row].name, fontSize: 15)
        cell.nameLabel.attributedText = attributedNameString
        
        let textColor = UIColor(red: 25.0 / 255, green: 63.0 / 255, blue: 110.0 / 255, alpha: 1.0)
        cell.nameLabel.textColor = textColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let sender = self.tableView.cellForRow(at: indexPath) as? SettingsCell{
            
            if sender.nameLabel.text == CellNameImagePair.alarmCell.name {
                performSegue(withIdentifier: CellNameImagePair.alarmCell.identifier, sender: sender)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 애플워치 연동
        if segue.identifier == "applewatch" {
            
        }
        // 알림 설정
        else if segue.identifier == "alarm" {
            
        }
        // 도움말
        else if segue.identifier == "help" {
            
        }
    }
}
