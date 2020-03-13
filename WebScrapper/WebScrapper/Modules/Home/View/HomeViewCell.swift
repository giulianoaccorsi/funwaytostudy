//
//  HomeViewCell.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewCell: UITableViewCell {
    let rowLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "SFProDisplay-Bold", size: 15)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "SFProDisplay-Bold", size: 15)
        return label
    }()
}

extension HomeViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(rowLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    func setupCell(infoMoney: InfoMoney) {
        rowLabel.text = infoMoney.name
        descriptionLabel.text = infoMoney.description
    }
    
    func setUpConstraints() {
        rowLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(snp.leading).offset(16)
            make.height.equalTo(30)
            make.trailing.equalTo(descriptionLabel.snp.leading)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rowLabel.snp.top)
            make.height.equalTo(rowLabel.snp.height)
            make.leading.equalTo(rowLabel.snp.leading).offset(4)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setUpAdditionalConfiguration() {
    }
    
    
}
