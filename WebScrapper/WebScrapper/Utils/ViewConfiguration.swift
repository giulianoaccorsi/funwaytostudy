//
//  ViewConfiguration.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

protocol ViewConfiguration {
    func buildViewHierarchy()
    func setUpConstraints()
    func setUpAdditionalConfiguration()
    func setUpView()
}

extension ViewConfiguration {
    func setUpView() {
        buildViewHierarchy()
        setUpConstraints()
        setUpAdditionalConfiguration()
    }
}
