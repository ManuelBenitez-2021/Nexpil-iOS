//
//  EditableCardHolder.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

protocol InformationCardEditableHolder {
    func valueChanged(newValue: String, for identifier: String)
    func cardTapped(withIdentifier: String)
}
