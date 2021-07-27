//
//  AlarmTimeSelectModalTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit

class AlarmTimeSelectModalViewController: UIViewController {
    var selectedAlarmString: String?
    
    @IBOutlet weak var alarmTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmTableView.tableFooterView = UIView()
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
    }
}

extension AlarmTimeSelectModalViewController:UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmString.alarmStringCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSelectCell", for: indexPath)
        
        cell.textLabel?.text = AlarmString(rawValue: indexPath.row)?.getTimeInKoreanString()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        selectedAlarmString = cell?.textLabel?.text
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: "unwindToAlarmTableView", sender: nil)
    }
}
