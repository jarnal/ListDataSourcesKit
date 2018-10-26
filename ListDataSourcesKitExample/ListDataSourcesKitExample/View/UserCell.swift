//
//  UserCell.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 24/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import ListDataSourcesKit

struct UserCellViewModel {
    
    var firstName: String
    var lastName: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

class UserCell: UITableViewCell, ConfigurableNibReusableCell {
    
    typealias Model = UserCellViewModel
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func didMoveToSuperview() {
        self.selectionStyle = .none
    }
    
    func configure(withModel model: UserCellViewModel) {
        self.fullNameLabel.text = model.fullName
    }
}
