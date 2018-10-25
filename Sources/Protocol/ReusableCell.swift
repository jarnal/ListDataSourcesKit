//
//  ReusableCell.swift
//  PatientFitback
//
//  Created by Jonathan Arnal on 22/05/2018.
//  Copyright © 2018 Kévin MACHADO. All rights reserved.
//

import UIKit

public typealias NibReusableCell = NibLoadable & ReusableCell
public typealias ConfigurableNibReusableCell = NibReusableCell & ConfigurableCell

public protocol ReusableCell {
    static var cellIdentifier: String { get }
}
public extension ReusableCell where Self: UIView {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
