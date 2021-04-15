//
//  CurrencyTableViewCell.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 27.03.2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    

    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var charCodeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(currency: Currency) {
//        imageFlag.image = currency.imageFlag
        namelabel.text = currency.name
        charCodeLabel.text = currency.charCode
        valueLabel.text = "Курс: \(currency.value ?? "Данных нет")"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
