//
//  RealmEntityDataHandler.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import UIKit
import ListDataSourcesKit
import RealmSwift

public class RealmEntityDataHandler<ListDataView: CellParentViewProtocol, DataEntity: Object, DataCellView: ConfigurableNibReusableCell>: EntityDataHandler {
    
    public typealias DataProvider = Results<DataEntity>
    public typealias DataListView = ListDataView
    public typealias Entity = DataEntity
    public typealias CellView = DataCellView
    
    typealias DidChangeContentHandler = () -> Void

    public var dataProvider: DataProvider?
    public var dataSource: BridgedDataSource?

    public var dataListView: ListDataView!

    public func buildViewModel(withEntity entity: DataEntity) -> DataCellView.Model {
        fatalError("BuidViewModel should be overriden!")
    }

    public func fetch() throws {}
    
    /// ⚠️ Those closures allow controller to respond to specific events of Realm Database
    var didChangeContent: DidChangeContentHandler?

    var sortDescriptors: [NSSortDescriptor]?
    var predicate: NSPredicate?

    var token: NotificationToken?

    //****************************************************
    // MARK: - Initialize
    //****************************************************

    /// Initializes the data entity for a specific "list" view
    /// Keep in mind that it can be either a UITableView or UICollection
    ///
    /// - Parameter dataView: A UITableView or UICollection
    internal func initialize(forDataView dataView: ListDataView) {
        dataListView = dataView
    }

    //****************************************************
    // MARK: - Private Business
    //****************************************************

    /// 🔨 Build a the DataProvider for the current data handler
    /// In this case the provider will be a Resuls<DataEntitiy>
    ///
    /// - Returns: Configured data provider
    internal func buildDataProvider() -> DataProvider? {

        let realm = try! Realm()

        var objects = realm.objects(Entity.self)
        if let unwrappedPredicate = self.predicate {
            objects = objects.filter(unwrappedPredicate)
        }

        return objects
    }
}

extension RealmEntityDataHandler where ListDataView == UITableView, DataCellView: UITableViewCell {

    private var tableView: UITableView { return dataListView }
    
    /// 🏭 Initializes with a UITableView
    /// This convenience init exists because `buildDependencies`method can't be called with base init because of a lack of context
    /// Explanation: buildTableViewDataSource() needs to know if the cell will be either UITableViewCell or UICollectionViewCell
    /// After that it can configure correctly the data source (tableCellForRowAtIndexPath <=> collectionCellForItemAtIndexPath)
    public convenience init(forTableView tableView: UITableView) {
        self.init()
        
        initialize(forDataView: tableView)
        buildDependencies()
    }
    
    /// 🔨 Build dependencies
    func buildDependencies() {
        
        // Setting data source
        dataSource = buildTableViewDataSource()
        tableView.dataSource = dataSource
        
        // Keeping reference of data provider to avoid deallocation
        dataProvider = buildDataProvider()
        
        self.token = dataProvider!.observe { (changes) in
            
            switch changes {
            case .initial:
                DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
            case .update(_, let deletions, let insertions, let modifications):
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let strongSelf = self else { return}
                    
                    strongSelf.tableView.beginUpdates()
                    strongSelf.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    strongSelf.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .none)
                    strongSelf.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    strongSelf.tableView.endUpdates()
                    
                    strongSelf.didChangeContent?()
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
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
