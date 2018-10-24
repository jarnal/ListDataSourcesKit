//
//  DataCoordinator.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import CoreData

final class DataCoordinator {
    
    //MARK: - singleton
    private static var coordinator: DataCoordinator?
    public class var shared: DataCoordinator {
        if coordinator == nil {
            coordinator = DataCoordinator()
        }
        return coordinator!
    }
    
    //MARK: - init
    public var container : NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
    }
    
    //MARK: - perform methods
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        DataCoordinator.shared.container.performBackgroundTask(block)
    }
    
    static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        block(DataCoordinator.shared.container.viewContext)
    }
}
