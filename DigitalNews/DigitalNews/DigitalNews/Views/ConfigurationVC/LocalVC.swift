//
//  LocalVC.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 13/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit


enum TypeUserSettings: String {
    case country = "CountrySelected"
    case isoCountry = "ISOSelected"
    case category = "CategoryISO"
    case categoryIndex = "CategoryIndex"
}

protocol LocalDelegate: class {
    func didChangeText(text: String)
}

class LocalVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var controller: UserController?
    weak var delegate: LocalDelegate?

    override func viewDidLoad() {
        controller = UserController()
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tintColor = .orange
        
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
        self.tableView.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        
    }
    
    func darkModeDisable() {
        self.tableView.backgroundColor = .white
        
    }

}
extension LocalVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
            cell.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
            cell.textLabel?.textColor = .white
        }else {
            darkModeDisable()
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.numberOfRowsCountry() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = controller?.loadCountry(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.didChangeText(text: controller?.loadCountry(index: indexPath.row) ?? "")
        let valueToSave = controller?.getArrayCountry(index: indexPath.row)
        let countryName = valueToSave?.rawValue
        let isoCountry = valueToSave?.countryISO
        UserDefaults.standard.set(isoCountry, forKey: TypeUserSettings.isoCountry.rawValue)
        UserDefaults.standard.set(countryName, forKey: TypeUserSettings.country.rawValue)
        NotificationCenter.default.post(name: Notification.Name("UserChangedValue"), object: nil)
        self.navigationController?.popViewController(animated: true)
        

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
