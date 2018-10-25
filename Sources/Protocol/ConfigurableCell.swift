//
//  ConfigurableCell.swift
//  PatientFitback
//
//  Created by Jonathan Arnal on 05/06/2018.
//  Copyright © 2018 Kévin MACHADO. All rights reserved.
//

import Foundation

public protocol ConfigurableCell {
    
    associatedtype Model
    func configure(withModel model: Model)
}
