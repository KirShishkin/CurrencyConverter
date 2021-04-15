//
//  ChooseDateController.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 08.04.2021.
//

import UIKit

class ChooseDateController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showCoursesAction(_ sender: Any) {
        Model.shared.loadData(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}
