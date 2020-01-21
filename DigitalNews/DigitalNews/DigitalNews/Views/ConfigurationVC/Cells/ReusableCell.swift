//
//  CountryLanguageCell.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 14/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class ReusableCell: UITableViewCell {

    @IBOutlet weak var labelTexto: UILabel!
    @IBOutlet weak var labelTextoUserDefault: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
        }else {
            darkModeDisable()
        }
        
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        darkModeEnable()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        darkModeDisable()
        
    }
    
    func darkModeEnable() {
        self.backgroundColor = UIColor(red: 0.449, green: 0.449, blue: 0.449, alpha: 1.0)
        self.labelTextoUserDefault.textColor = .white
    }
    
    func darkModeDisable() {
        self.backgroundColor = .white
        self.labelTextoUserDefault.textColor = .lightGray
    }
    
    func setupCell(labelTexto: String, labelUserDefault: String, image: String) {
        self.imageCell.image = UIImage(named: image)
        self.labelTexto.text = labelTexto
        self.labelTextoUserDefault.text = labelUserDefault
    }
    
    func setupCellWithoutLabel(stringTexto: String, image: String) {
        self.imageCell.image = UIImage(named: image)
        labelTextoUserDefault.text = ""
        self.labelTexto.text = stringTexto
        
    }

    
}
