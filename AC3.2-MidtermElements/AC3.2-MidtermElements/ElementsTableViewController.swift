//
//  ElementsTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Victor Zhong on 12/8/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit
import Kingfisher

class ElementsTableViewController: UITableViewController {
    
    let cellIdentifier = "elementCellReuse"
    let cellSegue = "elementSegue"
    var elements = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        APIRequestManager.manager.getData(endPoint: "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements") { (data: Data?) in
            if  let validData = data,
                let validElements = Element.elements(from: validData) {
                print("We have elements! \(validElements.count)")
                self.elements = validElements
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cellElement = elements[indexPath.row]
        
        cell.textLabel?.text = cellElement.name
        cell.detailTextLabel?.text = "\(cellElement.symbol)(\(cellElement.number)) \(cellElement.weight)"
        
        let url = URL(string: cellElement.thumb)!
        cell.imageView?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        
//        APIRequestManager.manager.getData(endPoint: cellElement.thumb) { (data: Data?) in
//            if let validData = data,
//                let validImage = UIImage(data: validData) {
//                DispatchQueue.main.async {
//                    cell.imageView?.image = validImage
//                    cell.setNeedsLayout()
//                }
//            }
//        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailView = segue.destination as? DetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            detailView.element = elements[indexPath.row]
        }
    }
}
