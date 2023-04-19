//
//  ConverterController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 10.04.2021.
//

import UIKit

class ConverterController: UIViewController {
    
    private var coursesForDateLabel = UILabel()
    
    private var buttonFrom: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.titleLabel?.font = UIFont(name: "System-System", size: 25)
        return button
    }()
    
    private var buttonTo: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.titleLabel?.font = UIFont(name: "System-System", size: 25)
        return button
    }()
    
    private var textFrom = UITextField()
    private var textTo = UITextField()
    
    private var buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pushDoneAction))
    
    private var equelLabel: UILabel = {
        let label = UILabel()
        label.text = "="
        label.tintColor = .black
        return label
    }()
    
    private let selectCurrController = SelectCurrencyController()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation
        navigationItem.title = "Конвертер"
        
        // Setup UI
        view.backgroundColor = .white
        setupCoursesForDateLabel()
        setupButtonFromAndButtonTo()
        setupEquelTextFromAndTextTo()

        textFrom.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditingChange()
        coursesForDateLabel.text = "Курсы за дату: \(Model.shared.currentDate)"
        navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Methods
    
    private func setupCoursesForDateLabel() {
        view.addSubview(coursesForDateLabel)
        coursesForDateLabel.translatesAutoresizingMaskIntoConstraints = false
        coursesForDateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:  200).isActive = true
        coursesForDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupButtonFromAndButtonTo() {
        let label = UILabel()
        view.addSubview(label)
        view.addSubview(buttonFrom)
        view.addSubview(buttonTo)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonFrom.translatesAutoresizingMaskIntoConstraints = false
        buttonTo.translatesAutoresizingMaskIntoConstraints = false
        
        buttonFrom.widthAnchor.constraint(equalToConstant: 123).isActive = true
        buttonFrom.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        buttonTo.widthAnchor.constraint(equalToConstant: 123).isActive = true
        buttonTo.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        buttonFrom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        label.leadingAnchor.constraint(equalTo: buttonFrom.trailingAnchor, constant: 34).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: coursesForDateLabel.bottomAnchor, constant: 80).isActive = true
        buttonTo.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 34).isActive = true
        buttonTo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        buttonFrom.addTarget(self, action: #selector(pushFromAction), for: .touchUpInside)
        buttonTo.addTarget(self, action: #selector(pushToAction), for: .touchUpInside)
    }
    
    private func setupEquelTextFromAndTextTo() {
        view.addSubview(textTo)
        view.addSubview(textFrom)
        view.addSubview(equelLabel)
        
        textFrom.borderStyle = .roundedRect
        textTo.borderStyle = .roundedRect
        
        textTo.translatesAutoresizingMaskIntoConstraints = false
        textFrom.translatesAutoresizingMaskIntoConstraints = false
        equelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textTo.widthAnchor.constraint(equalToConstant: 122).isActive = true
        textTo.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        textFrom.widthAnchor.constraint(equalToConstant: 123).isActive = true
        textFrom.heightAnchor.constraint(equalToConstant: 41).isActive = true
        
        textFrom.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textFrom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        textFrom.topAnchor.constraint(equalTo: buttonFrom.bottomAnchor, constant: 50).isActive = true
        
        equelLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textFrom.trailingAnchor).isActive = true
        equelLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        equelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textTo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textTo.leadingAnchor.constraint(greaterThanOrEqualTo: equelLabel.trailingAnchor).isActive = true
        textTo.topAnchor.constraint(equalTo: buttonTo.bottomAnchor, constant: 50).isActive = true
        textTo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        textFrom.keyboardType = .numberPad
        textFrom.addTarget(self, action: #selector(textFromEditingChange), for: .editingChanged)
    }
    
    @objc private func pushFromAction() {
        let nc = UINavigationController(rootViewController: selectCurrController)
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        buttonFrom.setTitle(Model.shared.fromCurrency.charCode, for: UIControl.State.normal)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
    
    @objc private func pushToAction() {
        let nc = UINavigationController(rootViewController: selectCurrController)
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        buttonTo.setTitle(Model.shared.toCurrency.charCode, for: UIControl.State.normal)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
    
    @objc private func textFromEditingChange() {
        let amount = Double(textFrom.text!)
            textTo.text = Model.shared.convert(amount: amount)
    }
    
    @objc private func pushDoneAction() {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    private func refreshButtons() {
        buttonFrom.setTitle(Model.shared.fromCurrency.charCode, for: UIControl.State.normal)
        buttonTo.setTitle(Model.shared.toCurrency.charCode, for: UIControl.State.normal)
    }
}

extension ConverterController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
}
