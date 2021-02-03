//
//  LoginViewController.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 25/01/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let logoImpactaImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "teste") 
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let registroAlunoTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = Strings.registroAlunoPlaceHolder
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = Strings.passwordPlaceHolder
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .cinzaImpacta
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.loginTitle, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loginButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc func tappedButton() {
        let viewController = HomeTabBarController()
        viewController.modalPresentationStyle = .overFullScreen 
        present(viewController, animated: true, completion: nil)
        
    }
    
    func setupUI() {
        
        self.view.addSubview(logoImpactaImage)
        self.view.addSubview(registroAlunoTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        
        logoImpactaImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImpactaImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImpactaImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        logoImpactaImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        logoImpactaImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        
        registroAlunoTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        registroAlunoTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        registroAlunoTextField.topAnchor.constraint(equalTo: logoImpactaImage.bottomAnchor, constant: 100).isActive = true
//        registroAlunoTextField.heightAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: registroAlunoTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
}
