//
//  EntityDataSource.swift
//  PatientFitback
//
//  Created by Jonathan Arnal on 22/05/2018.
//  Copyright © 2018 Kévin MACHADO. All rights reserved.
//

import UIKit
import CoreData

public protocol EntityDataHandler: class where DataProvider.Item == Entity {
    
    associatedtype DataProvider: DataProviderProtocol
    associatedtype DataListView: CellParentViewProtocol
    associatedtype Entity
    associatedtype CellView: ConfigurableNibReusableCell
    
    var dataListView: DataListView! { get set }
    
    var dataProvider: DataProvider? { get }
    var dataSource: BridgedDataSource? { get }
    
    func buildViewModel(withEntity entity: Entity) -> CellView.Model
    
    func fetch() throws
    
    /// ⚠️ Those closures allow controller to respond to specific events of FetchedResultController
    /// Basically this is not needed, only for specific controller business
    var willChangeContent: BridgedFetchedResultsDelegate.WillChangeContentHandler? { get set }
    var didChangeSection: BridgedFetchedResultsDelegate.DidChangeSectionHandler? { get set }
    var didChangeObject: BridgedFetchedResultsDelegate.DidChangeObjectHandler? { get set }
    var didChangeContent: BridgedFetchedResultsDelegate.DidChangeContentHandler? { get set }
}
