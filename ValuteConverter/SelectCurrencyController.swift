//
//  SelectCurrencyController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 10.04.2021.
//

import UIKit

enum FlagCurrencySelected {
    case from
    case to
}

class SelectCurrencyController: UITableViewController {
    
    var flagCurrency: FlagCurrencySelected = .from
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChooseCurrencyCell")
        
        navigationItem.title = "Выберите валюту"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currentcies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath)
        
        let currentCurrency: Currency = Model.shared.currentcies[indexPath.row]
        
        cell.textLabel?.text = currentCurrency.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency: Currency = Model.shared.currentcies[indexPath.row]
        if flagCurrency == .from {
            Model.shared.fromCurrency = selectedCurrency
        }
        if flagCurrency == .to {
            Model.shared.toCurrency = selectedCurrency
        }
        
        dismiss(animated: true, completion: nil)
    }
}
