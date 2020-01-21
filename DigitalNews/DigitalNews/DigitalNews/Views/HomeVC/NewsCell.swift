//
//  NewsCell.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 07/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCell: UITableViewCell {
    @IBOutlet weak var imageNews: UIImageView!

    @IBOutlet weak var labelSource: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var viewSombra: StyleView!
    
    @IBOutlet weak var viewClipBounds: StyleView!
    
    
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
        self.labelTitulo.textColor = .white
        self.labelDescription.textColor = .lightGray
        self.labelSource.textColor = .lightGray
        self.viewSombra.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        self.viewClipBounds.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        
    }
    
    func darkModeDisable() {
        self.backgroundColor = .white
        self.labelTitulo.textColor = .black
        self.labelDescription.textColor = .lightGray
        self.labelSource.textColor = .lightGray
        self.viewSombra.backgroundColor = .white
        self.viewClipBounds.backgroundColor = .white
        
    }
    
    func setupCell(article: Article) {
        let titulo = article.title?.components(separatedBy: "-")[0]
        imageNews.sd_setImage(with: URL(string: article.urlToImage ?? ""))
        labelSource.text = article.source?.name
        labelTitulo.text = titulo
        labelDescription.text = article.articleDescription
    }
    
}
