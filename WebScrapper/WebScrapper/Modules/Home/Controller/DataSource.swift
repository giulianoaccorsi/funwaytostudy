//
//  DataSource.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit

protocol DataSourceDelegate: class {
    func didScroll()
    func didSelected()
    func favoriteMovie()
}

class DataSource: NSObject {
    private var tableview: UITableView
    private let delegate: DataSourceDelegate
    private let identifier: String = "infoMoney"
    private var htmlParsed: [String] = []
    
    init(tableView: UITableView, delegate: DataSourceDelegate) {
        self.delegate = delegate
        self.tableview = tableView
        super.init()
        registerCell()
    }
    
    func registerCell() {
        tableview.register(HomeViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    func setupDataSource() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func updateDataSource(array: [String]) {
        self.htmlParsed = array
        tableview.reloadData()
    }
}

extension DataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return htmlParsed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: HomeViewCell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? HomeViewCell else {return UITableViewCell()}
        cell.setupCell(infoMoney: <#T##InfoMoney#>)
        
    }
    
    
}

extension DataSource: UITableViewDelegate {
    
}
