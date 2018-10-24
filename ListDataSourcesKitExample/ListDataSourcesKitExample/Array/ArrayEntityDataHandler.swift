//
//  ArrayEntityDataHandler.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import Foundation
import ListDataSourcesKit

class ArrayEntityDataHandler<ListDataView: CellParentViewProtocol, DataEntity: Any, DataCellView: ConfigurableNibReusableCell>: EntityDataHandler {
    
    typealias DataProvider = Array< Array<DataEntity> >
    typealias DataListView = ListDataView
    typealias Entity = DataEntity
    typealias CellView = DataCellView
    
    var dataProvider: DataProvider?
    var dataSource: BridgedDataSource?
    
    var dataListView: ListDataView!
    
    func buildViewModel(withEntity entity: DataEntity) -> DataCellView.Model {
        fatalError("BuidViewModel should be overriden!")
    }
    
    func fetch() throws {}
    
    /// ⚠️ Those closures allow controller to respond to specific events of FetchedResultController
    /// Basically this is not needed, only for specific controller business
    var willChangeContent: BridgedFetchedResultsDelegate.WillChangeContentHandler?
    var didChangeSection: BridgedFetchedResultsDelegate.DidChangeSectionHandler?
    var didChangeObject: BridgedFetchedResultsDelegate.DidChangeObjectHandler?
    var didChangeContent: BridgedFetchedResultsDelegate.DidChangeContentHandler?
    
    var sortDescriptors: [NSSortDescriptor]?
    var predicate: NSPredicate?
    
    var data: DataProvider?
    
    //****************************************************
    // MARK: - Initialize
    //****************************************************
    
    /// Initializes the data entity for a specific "list" view
    /// Keep in mind that it can be either a UITableView or UICollection
    ///
    /// - Parameter dataView: A UITableView or UICollection
    init(forDataView dataView: ListDataView) {
        dataListView = dataView
    }
    
    //****************************************************
    // MARK: - Private Business
    //****************************************************
    
    /// 🔨 Build a the DataProvider for the current data handler
    /// In this case the provider will be a FetchedResultController
    ///
    /// - Returns: Configured data provider
    internal func buildDataProvider() -> DataProvider? {
        return self.data
    }
}

extension ArrayEntityDataHandler where ListDataView == UITableView, DataCellView: UITableViewCell {

    private var tableView: UITableView { return dataListView }

    convenience init(forDataView dataView: ListDataView, withData data: DataProvider) {
        self.init(forTableView: dataView, shouldStartProviding: true)
        
        self.data = data
        
        // Setting data source
        dataSource = buildTableViewDataSource()
        
        // Keeping reference of data provider to avoid deallocation
        dataProvider = buildDataProvider()
    }
    
    convenience init(forTableView tableView: ListDataView, shouldStartProviding: Bool = true) {
        self.init(forDataView: tableView)
    }

    /// 🔨 Build a data source for the specific need of a UITableView
    /// ℹ️ Keep in mind that the real data is owned by the data provider
    /// ℹ️ This object will just act as the UITableViewDataSource
    ///
    /// - Returns: Configured ready to use data source for the related tableView
    func buildTableViewDataSource() -> BridgedDataSource? {

        let dataSource = BridgedDataSource(
            numberOfSections: { [unowned self] () -> Int in
                return self.dataProvider!.numberOfSections()
            },
            numberOfItemsInSection: { [unowned self] (section) -> Int in
                return self.dataProvider!.numberOfItems(inSection: section)
        })

        dataSource.tableCellForRowAtIndexPath = { [unowned self] (tableView, indexPath) in

            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: CellView.cellIdentifier, for: indexPath) as? CellView,
                let entity = self.dataProvider!.item(atRow: indexPath.row, inSection: indexPath.section)
                else {
                    fatalError("Impossible to configure the cell!")
            }

            let viewModel = self.buildViewModel(withEntity: entity)
            cell.configure(withModel: viewModel)

            return cell
        }

        dataSource.tableCanEditRow = { (tableView, indexPath) in
            return true
        }

        return dataSource
    }

}
