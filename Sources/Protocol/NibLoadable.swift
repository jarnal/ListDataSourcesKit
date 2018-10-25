//
//  NibLoadable.swift
//  PatientFitback
//
//  Created by Jonathan Arnal on 12/04/2017.
//  Copyright © 2017 Kévin MACHADO. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {}
public extension NibLoadable where Self: UIView {
    
    /// Nib name of the UIView
    static var nibName: String {
        return String(describing: self)
    }
    
    /// Nib instance
    static var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: nil)
    }
    
    /// Returns an instance of the view wich extends the protocol
    static var instanceFromNib: Self {
        let view: Self = Self.nib.instantiate(withOwner: nil, options: nil)[0] as! Self
        return view
    }
}
