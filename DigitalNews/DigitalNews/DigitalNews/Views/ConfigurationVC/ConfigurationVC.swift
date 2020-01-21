//
//  ConfigurationVC.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 06/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

enum Section: Int {
    case numberOfSection = 4
    case rowsSectionProfileNotification = 1
    case rowsSectionCountryCategoryThirdAbout = 2
}

enum SectionIndex: Int {
    case Profile = 0
    case Notification = 1
    case CountryCategory = 2
    case ThirdAbout = 3
    
}

class ConfigurationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let controller = UserController()
    var palavra: String = UserDefaults.standard.string(forKey: TypeUserSettings.country.rawValue) ?? "Brasil" {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
        }else {
            darkModeDisable()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        self.tableView.register(UINib(nibName: "ReusableCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        self.tableView.register(UINib(nibName: "UserProfileCell", bundle: nil), forCellReuseIdentifier: "UserProfileCell")
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func Logout(_ sender: Any) {
        if AccessToken.current != nil {
            AccessToken.current = nil
            self.dismiss(animated: true)
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
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    func darkModeDisable() {
        self.tableView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    
    
}

extension ConfigurationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSection.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionIndex.Profile.rawValue:
            return Section.rowsSectionProfileNotification.rawValue
        case SectionIndex.Notification.rawValue:
            return Section.rowsSectionProfileNotification.rawValue
        case SectionIndex.CountryCategory.rawValue:
            return Section.rowsSectionCountryCategoryThirdAbout.rawValue
        case SectionIndex.ThirdAbout.rawValue:
            return Section.rowsSectionCountryCategoryThirdAbout.rawValue
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewTop = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
        
        if (section == 1) {
            headerViewTop.backgroundColor = UIColor.clear
            return headerViewTop
        } else {
            headerView.backgroundColor = UIColor.clear
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 90
        }
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case SectionIndex.Profile.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell else { return UITableViewCell()}
        
            
            cell.setupCellUser(name: UserDefaults.standard.string(forKey: "NomeFacebook") ?? "")
            cell.selectionStyle = .none
            return cell
            
            
        case SectionIndex.Notification.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell else { return UITableViewCell()}
            cell.setupNotifCell(labelTexto: "Modo Escuro", image: "darkMode")
            return cell
            
            
        case SectionIndex.CountryCategory.rawValue:
            switch indexPath.row{
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? ReusableCell else {return UITableViewCell()}
                cell.setupCell(labelTexto: "País", labelUserDefault: self.palavra, image: "world480")
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? ReusableCell else {return UITableViewCell()}
                cell.setupCellWithoutLabel(stringTexto: "Categoria", image: "category480")
                return cell
            default:
                return UITableViewCell()
            }
            
        case SectionIndex.ThirdAbout.rawValue:
            switch indexPath.row{
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? ReusableCell else {return UITableViewCell()}
                cell.setupCellWithoutLabel(stringTexto: "Reconhecimento de Terceiros", image: "reconhecimento480")
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? ReusableCell else {return UITableViewCell()}
                cell.setupCellWithoutLabel(stringTexto: "Sobre", image: "about480")
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            switch indexPath.section {
                
            case SectionIndex.Profile.rawValue:
                self.tableView.deselectRow(at: indexPath, animated: false)
                
                
            case SectionIndex.Notification.rawValue:
                self.tableView.deselectRow(at: indexPath, animated: false)
                
        
            case SectionIndex.CountryCategory.rawValue:
                switch indexPath.row {
                case 0:
                    self.tableView.deselectRow(at: indexPath, animated: false)
                    guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LocalVC") as? LocalVC else {return}
                    viewController.delegate = self
                    self.navigationController?.pushViewController(viewController, animated: true)
                case 1:
                    self.tableView.deselectRow(at: indexPath, animated: false)
                    guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC else {return}
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                default: break
                }
            case SectionIndex.ThirdAbout.rawValue:
                switch indexPath.row {
                case 0:
                    self.tableView.deselectRow(at: indexPath, animated: false)
                    guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ThirdPartyVC") as? ThirdPartyVC else {return}
                    self.navigationController?.pushViewController(viewController, animated: true)
                case 1:
                    self.tableView.deselectRow(at: indexPath, animated: false)
                    let alertController = UIAlertController(title: "Digital News", message: "App criado por:\nGiuliano Accorsi\nPaulo Ricardo", preferredStyle: .alert)
                    let button = UIAlertAction(title: "Okay", style: .default)
                    button.setValue(UIColor.orange, forKey: "titleTextColor")
                    alertController.addAction(button)
                    present(alertController, animated: true)
                default: break
                    
                    
                }
            default:break
            }
        }
    }

extension ConfigurationVC: LocalDelegate {    
    func didChangeText(text: String) {
        self.palavra = text
        
    }
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}
        

