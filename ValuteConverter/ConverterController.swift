//
//  ConverterController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 10.04.2021.
//

import UIKit

class ConverterController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var coursesForDateLabel: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    @IBOutlet weak var equelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFrom.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func pushFromAction(_ sender: Any) {
       let nc = storyboard?.instantiateViewController(identifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @IBAction func pushToAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(identifier: "selectedCurrencyNSID") as! UINavigationController
         (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
         nc.modalPresentationStyle = .fullScreen
         present(nc, animated: true, completion: nil)
    }
    
    @IBAction func textFromEditingChange(_ sender: Any) {
        let amount = Double(textFrom.text!)
            textTo.text = Model.shared.convert(amount: amount)
    }
    
    @IBAction func pushDoneAction(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditingChange(self)
        coursesForDateLabel.text = "Курсы за дату: \(Model.shared.currentDate)"
        navigationItem.rightBarButtonItem = nil
    }
    
    func refreshButtons() {
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
