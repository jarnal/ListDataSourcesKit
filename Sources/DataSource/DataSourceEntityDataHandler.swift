//
//  DataSourceEntityDataHandler.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 24/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import UIKit

open class DataSourceEntityDataHandler<ListDataView: CellParentViewProtocol, DataEntity: Any, DataCellView: ConfigurableNibReusableCell>: EntityDataHandler {
    
    public typealias DataProvider = DataSource<DataEntity>
    public typealias DataListView = ListDataView
    public typealias Entity = DataEntity
    public typealias CellView = DataCellView
    
    public var dataProvider: DataProvider?
    public var dataSource: BridgedDataSource?
    
    public var dataListView: ListDataView!
    
    open func buildViewModel(withEntity entity: DataEntity) -> DataCellView.Model {
        fatalError("BuidViewModel should be overriden!")
    }
    
    public func fetch() throws {}
    
    //****************************************************
    // MARK: - Initialize
    //****************************************************
    
    /// 🏭 Initializes the data entity for a specific "list" view
    /// Keep in mind that it can be either a UITableView or UICollection
    ///
    /// - Parameters:
    ///   - dataView: A UITableView or UICollection
    ///   - data: static data
    public init(forDataView dataView: ListDataView, withData data: DataProvider) {
        dataListView = dataView
        dataProvider = data
    }
    
    //****************************************************
    // MARK: - Private Business
    //****************************************************
    
    /// 🔨 Build a the DataProvider for the current data handler
    /// In this case the provider will be a FetchedResultController
    ///
    /// - Returns: Configured data provider
    internal func buildDataProvider() -> DataProvider? {
        return dataProvider
    }
}

extension DataSourceEntityDataHandler where ListDataView == UITableView, DataCellView: UITableViewCell {
    
    private var tableView: UITableView { return dataListView }
    
    /// 🔨Build the necessary dependencies
    public func buildDependencies (){
        
        // Setting data source
        dataSource = buildTableViewDataSource()
        tableView.dataSource = dataSource
        
        // Keeping reference of data provider to avoid deallocation
        dataProvider = buildDataProvider()
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
        
        dataSource.tableTitleForHeaderInSection = {  [unowned self] (section) -> String? in
            return self.dataProvider!.headerTitle(inSection: section)
        }
        
        dataSource.tableTitleForFooterInSection = {  [unowned self] (section) -> String? in
            return self.dataProvider!.footerTitle(inSection: section)
        }
        
        dataSource.tableCanEditRow = { (tableView, indexPath) in
            return true
        }
        
        return dataSource
    }
    
}

