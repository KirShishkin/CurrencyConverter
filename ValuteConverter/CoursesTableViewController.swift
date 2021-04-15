//
//  CoursesTableViewController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 08.04.2021.
//

import UIKit

class CoursesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "startLoadingXML"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                let activIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                activIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activIndicator
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dataRefreshed"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = Model.shared.currentDate
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ErrorWhenXMLloading"), object: nil, queue: nil) { (notification) in
            //let errorName = notification.userInfo?["ErrorName"]
            //print(errorName)
            
//            let ac = UIAlertController(title: "Error", message: errorName as? String, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//            ac.addAction(okAction)
//            present(ac, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        
        navigationItem.title = Model.shared.currentDate
        
        Model.shared.loadData(date: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButton(_ sender: Any) {
        Model.shared.loadData(date: nil)
    }
    
    @IBAction func chooseDateButton(_ sender: Any) {
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currentcies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CurrencyTableViewCell
        
        let courseForCell = Model.shared.currentcies[indexPath.row]
        
        cell.initCell(currency: courseForCell)

        return cell
    }
}
