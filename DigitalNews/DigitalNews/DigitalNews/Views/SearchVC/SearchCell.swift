//
//  SearchCell.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 24/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var textNews: UILabel!
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
        self.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        self.textNews.textColor = .white
        
    }
    
    func darkModeDisable() {
        self.backgroundColor =  .white
        self.textNews.textColor = .black
        
    }
    
    func setupCell(title: Article) {
        self.textNews.text = title.title
    }
    
}
