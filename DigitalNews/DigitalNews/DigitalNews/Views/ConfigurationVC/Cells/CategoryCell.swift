//
//  CategoryCell.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 15/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var checkMark: CheckMarkView!
    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var labelCategory: UILabel!
    
    override func awakeFromNib() {
        viewCell.layer.cornerRadius = 30
        viewCell.clipsToBounds = true
    }
    
    func setupCell(textLabel: String, isSelected: Bool) {
        self.checkMark.checked = isSelected
        
       self.labelCategory.text = textLabel
        self.checkMark.style = .grayedOut
        self.checkMark.setNeedsDisplay()
    }

}
