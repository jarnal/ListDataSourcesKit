//
//  ViewController.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 22/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import UIKit
import ListDataSourcesKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test4()
    }
    
    func test1() {
        
        let user1 = RealmUser()
        user1.firstName = "Bob"
        user1.lastName = "L'éponge"

        let user2 = RealmUser()
        user2.firstName = "Peter"
        user2.lastName = "Pan"
        
        let data = [user1, user2]
        arrayDataHandler = UserArrayEntityHandler(forDataView: self.tableView, withData: data)
        // Set in protocol ?
        arrayDataHandler.buildDependencies()
        tableView.reloadData()
    }
    
    func test2() {
        let user1 = RealmUser()
        user1.firstName = "Bob"
        user1.lastName = "L'éponge"
        
        let user2 = RealmUser()
        user2.firstName = "Peter"
        user2.lastName = "Pan"
        
        let sections = [
            Section([user1, user2], headerTitle: "First users", footerTitle: nil),
            Section([user1, user2], headerTitle: "Second users", footerTitle: nil)
        ]
        let data: DataSource<RealmUser> = DataSource( sections )
        
        dataSourceDataHandler = UserDataSourceEntityHandler(forDataView: self.tableView, withData: data)
        dataSourceDataHandler.buildDependencies()
        tableView.reloadData()
    }
    
    func test3() {
        
        DataCoordinator.performViewTask { (context) in
            let user1 = User(context: context)
            user1.firstname = "Bob"
            user1.lastname = "L'éponge"
            
            let user2 = User(context: context)
            user2.firstname = "Peter"
            user2.lastname = "Pan"
            
            try? context.save()
            
        }
        
        DataCoordinator.performViewTask { (context) in
            let users = try! context.fetch( User.fetchRequest() )
            print(users)
        }
        
        coreDataHander = UserCoreDataDataHandler(forTableView: self.tableView, managedObjectContext: DataCoordinator.shared.container.viewContext)
        try! coreDataHander.fetch()
        tableView.reloadData()
    }
    
    func test4() {
        
        let user1 = RealmUser()
        user1.id = "1"
        user1.firstName = "Bob1"
        user1.lastName = "L'éponge1"
        
        let user2 = RealmUser()
        user2.id = "2"
        user2.firstName = "Peter2"
        user2.lastName = "Pan2"
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(user1, update: true)
        realm.add(user2, update: true)
        try? realm.commitWrite()

        realmEntityHandler = UserRealmEntityHandler(forDataView: tableView)
        realmEntityHandler.buildDependencies()
        
        realmEntityHandler.didChangeContent = {
            print("🔥 didChangeContent")
        }
        
        realm.beginWrite()
        user1.firstName = "Lalala"
        realm.add(user1, update: true)
        try? realm.commitWrite()
        
        try! realmEntityHandler.fetch()
        tableView.reloadData()
    }
    
    var coreDataHander: UserCoreDataDataHandler<UITableView, UserCell>!
    var arrayDataHandler: UserArrayEntityHandler!
    var dataSourceDataHandler: UserDataSourceEntityHandler!
    var realmEntityHandler: UserRealmEntityHandler!

}
