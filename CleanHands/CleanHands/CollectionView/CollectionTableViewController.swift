//
//  CollectionTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/05/07.
//

import UIKit

class CollectionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dummyPathogenDic.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        // Configure the cell...
        // dummyPathoganDic의 시작 index부터 indexpath.row만큼 떨어진 index를 가져온다.
        let index = dummyPathogenDic.index(dummyPathogenDic.startIndex, offsetBy: indexPath.row)
        cell.item = dummyPathogenDic.keys[index]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow,
           let detailVC = segue.destination as? CollectionDetailViewController {
            let index = dummyPathogenDic.index(dummyPathogenDic.startIndex, offsetBy: indexPath.row)
            detailVC.selectedPathogen = dummyPathogenDic.keys[index]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
     */

    
    
}

class CollectionCell : UITableViewCell {
    
    @IBOutlet weak var pathoganLabel: UILabel!
    @IBOutlet weak var eliminatedCountLabel: UILabel!
    @IBOutlet weak var pathoganImage: UIImageView!
    
    var item: Pathogen? {
        didSet {
            guard let pathogan = item else {
                return
            }
            pathoganImage.image = UIImage(named: "salmonella.png")
            pathoganLabel.text = pathogan.name
            eliminatedCountLabel.text = "100"
        }
    }
}
