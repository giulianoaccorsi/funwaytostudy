//
//  NotificationCell.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 14/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var labelTexto: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var imageCell: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchButton.isOn = UserDefaults.standard.bool(forKey: "isDarkMode")
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
        }else {
            darkModeDisable()
        }
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "isDarkMode")
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
        }else {
            UserDefaults.standard.set(false, forKey: "isDarkMode")
             NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
        
    }
    
    func setupNotifCell (labelTexto: String, image: String) {
        self.selectionStyle = .none
        self.labelTexto.text = labelTexto
        self.imageCell.image = UIImage(named: image)
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        darkModeEnable()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        darkModeDisable()
        
    }
    
    func darkModeEnable() {
        self.backgroundColor = UIColor(red: 0.449, green: 0.449, blue: 0.449, alpha: 1.0)
    }
    
    func darkModeDisable() {
        self.backgroundColor = .white
    }
    
}
extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.DigitalNews.notifications.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.DigitalNews.notifications.darkModeDisabled")
}
