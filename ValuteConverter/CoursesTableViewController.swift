//
//  CoursesTableViewController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 08.04.2021.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    let datePicker:UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .gray
        return picker
    }()
    
    let chooseDateController = ChooseDateController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setap Controller
        self.tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.rowHeight = 100
        navigationItem.title = Model.shared.currentDate
        
        // Notification Center
        startLoadingIndicator()
        refreshedDataNotify()
        errorWhenXMLloading()
        
        //Date
        dateBarButtonItem()
        
        //Data
        Model.shared.loadData(date: nil)
    }
    
    private func dateBarButtonItem() {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .done, target: self, action: #selector(self.chooseDateButton))
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
        
    // MARK: - Notification Center
    
    func startLoadingIndicator() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "startLoadingXML"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                let activIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                activIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activIndicator
            }
        }
    }
    
    func refreshedDataNotify() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dataRefreshed"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = Model.shared.currentDate
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
    }
    
    func errorWhenXMLloading() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ErrorWhenXMLloading"), object: nil, queue: nil) { (notification) in
            let errorName = notification.userInfo?["ErrorName"]
            print(errorName ?? "")
            
            let ac = UIAlertController(title: "Error", message: errorName as? String, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(okAction)
            self.present(ac, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
    }
    
    @objc private func refreshButton() {
        Model.shared.loadData(date: nil)
    }
    
    @objc private func chooseDateButton() {
        let navChooseDateVC = UINavigationController(rootViewController: chooseDateController)
        present(navChooseDateVC, animated: true)
    }
    
    // MARK: - Table View Data Source
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

// MARK: - SwiftUI
import SwiftUI

struct CoursesTVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().previewDevice("iPhone 11").edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let coursesTVC = CoursesTableViewController()

        func makeUIViewController(context: Context) -> some UIViewController {
            return coursesTVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

    }
}
