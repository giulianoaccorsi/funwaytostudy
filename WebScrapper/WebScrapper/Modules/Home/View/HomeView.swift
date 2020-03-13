//
//  HomeView.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    let stockName: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Magazine Luiza (MGLU3)"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "SFProDisplay-Bold", size: 25)
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setUpView()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(stockName)
        addSubview(tableView)
    }
    
    func setUpConstraints() {
        stockName.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stockName.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setUpAdditionalConfiguration() {
    }
    
    
}
