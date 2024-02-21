//
//  WatchListViewController.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//

import UIKit
import CoreData

class WatchListViewController: UIViewController {
    
    var models = [MovieList]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadWatchList()
    }
    
    func loadWatchList(){
        models = CoreData.sharedInstance.getAllItems()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableView
extension WatchListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesListTableViewCell
        cell.setCellWithValuesOfCoreData(models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showAlert(withTitle: "Delete", withMessage: "\(self.models[indexPath.row].title ?? "") ?", indexPath: indexPath)
    }
}

extension WatchListViewController {

    func showAlert(withTitle title: String, withMessage message:String, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            let item = self.models[indexPath.row]
            CoreData.sharedInstance.deleteItem(item: item)
            self.models.removeAll()
            self.loadWatchList()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
