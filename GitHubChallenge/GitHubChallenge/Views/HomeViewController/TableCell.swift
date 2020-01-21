//
//  TableCell.swift
//  GitHubChallenge
//
//  Created by Giuliano Accorsi on 05/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import SDWebImage

class TableCell: UITableViewCell {
    @IBOutlet weak var imageAuthor: UIImageView!
    @IBOutlet weak var labelRepo: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageAuthor.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageAuthor.image = nil
    }

    func setupCell (item: Item) {
        self.labelRepo.text = item.name
        self.imageAuthor?.sd_setImage(with: URL(string: item.owner?.avatarURL ?? "")!, completed: nil)
        self.labelAuthor.text = item.owner?.login
        self.labelStar.text =  "✪ \(item.stargazersCount ?? 0)"
        
        
    }
    
}
