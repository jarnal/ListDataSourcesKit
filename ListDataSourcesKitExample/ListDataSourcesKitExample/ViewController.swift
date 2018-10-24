//
//  ViewController.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 22/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import UIKit
import ListDataSourcesKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test()
    }
    
    func test() {
        
        let user1 = RealmUser()
        user1.firstName = "Bob"
        user1.lastName = "L'éponge"
        
        let user2 = RealmUser()
        user2.firstName = "Peter"
        user2.lastName = "Pan"
        
        let data = [[user1, user2], [user1, user2]]
        dataHandler = UserArrayEntityData(forDataView: self.tableView, withData: data)
        
        tableView.dataSource = dataHandler?.dataSource
        tableView.reloadData()
    }
    
    var dataHandler: UserArrayEntityData?

}

struct UserCellViewModel {
    
    var firstName: String
    var lastName: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

class UserCell: UITableViewCell, ConfigurableNibReusableCell {
    
    typealias Model = UserCellViewModel
    typealias CellView = UITableView
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func didMoveToSuperview() {
        self.selectionStyle = .none
    }
    
    func configure(withModel model: UserCellViewModel) {
        self.fullNameLabel.text = model.fullName
    }
}

class UserArrayEntityData: ArrayEntityDataHandler<UITableView, RealmUser, UserCell> {
    
    override func buildViewModel(withEntity entity: RealmUser) -> UserCellViewModel {
        return UserCellViewModel(firstName: entity.firstName, lastName: entity.lastName)
    }
    
}

