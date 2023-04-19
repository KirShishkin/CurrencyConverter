//
//  CurrencyTableViewCell.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 27.03.2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    let namelabel = UILabel()
    let charCodeLabel = UILabel()
    let valueLabel = UILabel()

   // @IBOutlet weak var imageFlag: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraintsForCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraintsForCell() {
        let vertStack = UIStackView(arrangedSubviews: [namelabel, charCodeLabel, valueLabel])
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        charCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        vertStack.axis = .vertical
        vertStack.spacing = 10
        
        contentView.addSubview(vertStack)
        
        vertStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        vertStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        vertStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        vertStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
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
