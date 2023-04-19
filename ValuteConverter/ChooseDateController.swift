//
//  ChooseDateController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 08.04.2021.
//

import UIKit

class ChooseDateController: UIViewController {

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let showButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать курс", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation
        navigationItem.title = "Выберите дату"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        
        // Setup UI
        view.backgroundColor = .white
        setupDatePicker()
        setupShowButton()
        
        showButton.addTarget(self, action: #selector(showCoursesAction), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 190)
    }
    
    private func setupShowButton() {
        view.addSubview(showButton)
        showButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 70).isActive = true
        showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func showCoursesAction() {
        Model.shared.loadData(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}
