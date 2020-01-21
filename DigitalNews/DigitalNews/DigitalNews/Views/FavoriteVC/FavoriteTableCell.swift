//
//  FavoriteTableCell.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 19/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteTableCell: UITableViewCell {

    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var viewUm: StyleView!
    
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
        self.labelTitulo.textColor = .white
        self.labelDesc.textColor = .lightGray
        self.viewUm.backgroundColor = UIColor(red: 0.449, green: 0.449, blue: 0.449, alpha: 1.0)
        
    }
    
    func darkModeDisable() {
        self.backgroundColor = .white
        self.labelTitulo.textColor = .black
        self.labelDesc.textColor = .lightGray
        self.viewUm.backgroundColor = .white
        
    }

    func setupCell(news: NewsSaved) {
        
        self.newsImage.sd_setImage(with: URL(string: news.urlToImage ?? ""))
        self.labelTitulo.text = news.title
        self.labelDesc.text = news.descNews
    }
    
}
