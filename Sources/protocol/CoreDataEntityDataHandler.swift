////
////  CoreDataEntityDataHandler.swift
////  PatientFitback
////
////  Created by Jonathan Arnal on 22/05/2018.
////  Copyright © 2018 Kévin MACHADO. All rights reserved.
////
//
//import UIKit
//import CoreData
//
/////
//class CoreDataEntityDataHandler<ListDataView: CellParentViewProtocol, DataEntity: NSFetchRequestResult, DataCellView: ConfigurableNibReusableCell>: EntityDataHandler, CoreDataDependent {
//    
//    //****************************************************
//    // MARK: - EntityDataHandler Conformance
//    //****************************************************
//    
//    typealias DataProvider = FetchedResultsController<DataEntity>
//    typealias DataListView = ListDataView
//    typealias Entity = DataEntity
//    typealias CellView = DataCellView
//    
//    var dataProvider: DataProvider?
//    var dataSource: BridgedDataSource?
//    
//    var dataListView: ListDataView!
//    
//    func buildViewModel(withEntity entity: DataEntity) -> DataCellView.Model {
//        fatalError("BuidViewModel should be overriden!")
//    }
//    
//    //****************************************************
//    // MARK: - CoreDataDependent Conformance
//    //****************************************************
//    
//    internal var sortDescriptors: [NSSortDescriptor]?
//    internal var predicate: NSPredicate?
//    internal var sectionNameKeyPath: String?
//    internal var cacheName: String?
//    
//    internal lazy var sectionChanges = [() -> Void]()
//    internal lazy var objectChanges = [() -> Void]()
//    
//    //****************************************************
//    // MARK: - Fetched Result Controller Event Handlers
//    //****************************************************
//    
//    /// ⚠️ Those closures allow controller to respond to specific events of FetchedResultController
//    /// Basically this is not needed, only for specific controller business
//    public var willChangeContent: WillChangeContentHandler?
//    public var didChangeSection: DidChangeSectionHandler?
//    public var didChangeObject: DidChangeObjectHandler?
//    public var didChangeContent: DidChangeContentHandler?
//    
//    //****************************************************
//    // MARK: - Initialize
//    //****************************************************
//    
//    /// Initializes the data entity for a specific "list" view
//    /// Keep in mind that it can be either a UITableView or UICollection
//    ///
//    /// - Parameter dataView: A UITableView or UICollection
//    init(forDataView dataView: ListDataView) {
//        
//        dataListView = dataView
//    }
//    
//    //****************************************************
//    // MARK: - Public API
//    //****************************************************
//    
//    /// Update fetch request with new predicate and sorting
//    ///
//    /// - Throws: error if fetching fails
//    public func fetch() throws {
//        
//        guard let provider = self.dataProvider else { return }
//        provider.fetchRequest.predicate = predicate
//        provider.fetchRequest.sortDescriptors = sortDescriptors
//        
//        do {
//            try provider.performFetch()
//        } catch {
//            throw error
//        }
//    }
//    
//    //****************************************************
//    // MARK: - Private Business
//    //****************************************************
//    
//    /// Contains the delegate for the FetchedResultController
//    /// Implementention will depend on type of dataListView (in extensions)
//    internal var bridgedFetchedResultsDelegate: BridgedFetchedResultsDelegate?
//    
//    /// 🔨 Build a the DataProvider for the current data handler
//    /// In this case the provider will be a FetchedResultController
//    ///
//    /// - Returns: Configured data provider
//    internal func buildDataProvider() -> FetchedResultsController<Entity>? {
//        
//        let entityName = String(describing: Entity.self)
//        let fetchRequest = NSFetchRequest<Entity>(entityName: entityName)
//        let entity = NSEntityDescription.entity(forEntityName: entityName, in: shared.apiStorage.managedObjectContext!)
//        fetchRequest.entity = entity
//        
//        fetchRequest.sortDescriptors = sortDescriptors
//        
//        if let predicate = self.predicate {
//            fetchRequest.predicate = predicate
//        }
//        
//        // 🔨 Building fetched result controller depending on dependencies (predicate, sorting, etc...)
//        let fetchedResultsController: FetchedResultsController<Entity> = FetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: shared.apiStorage.managedObjectContext!,
//            sectionNameKeyPath: self.sectionNameKeyPath,
//            cacheName: self.cacheName
//        )
//        
//        // Setting correct delegate directly
//        fetchedResultsController.delegate = self.bridgedFetchedResultsDelegate
//        
//        return fetchedResultsController
//    }
//    
//}
//
//extension CoreDataEntityDataHandler where ListDataView == UITableView, DataCellView: UITableViewCell {
//    
//    private var tableView: UITableView { return dataListView }
//    
//    convenience init(forTableView tableView: ListDataView, shouldStartProviding: Bool = true) {
//        self.init(forDataView: tableView)
//        
//        // Setting data source
//        dataSource = buildTableViewDataSource()
//        bridgedFetchedResultsDelegate = buildBridgedFetchedResultsDelegate()
//        
//        // Keeping reference of data provider to avoid deallocation
//        dataProvider = buildDataProvider()
//    }
//    
//    /// 🔨 Build a data source for the specific need of a UITableView
//    /// ℹ️ Keep in mind that the real data is owned by the data provider
//    /// ℹ️ This object will just act as the UITableViewDataSource
//    ///
//    /// - Returns: Configured ready to use data source for the related tableView
//    func buildTableViewDataSource() -> BridgedDataSource? {
//        
//        let dataSource = BridgedDataSource(
//            numberOfSections: { [unowned self] () -> Int in
//                return self.dataProvider!.numberOfSections()
//            },
//            numberOfItemsInSection: { [unowned self] (section) -> Int in
//                return self.dataProvider!.numberOfItems(inSection: section)
//        })
//        
//        dataSource.tableCellForRowAtIndexPath = { [unowned self] (tableView, indexPath) in
//            
//            guard
//                let cell = tableView.dequeueReusableCell(withIdentifier: CellView.cellIdentifier, for: indexPath) as? CellView,
//                let entity = self.dataProvider!.item(atRow: indexPath.row, inSection: indexPath.section)
//                else {
//                    fatalError("Impossible to configure the cell!")
//            }
//            
//            let viewModel = self.buildViewModel(withEntity: entity)
//            cell.configure(withModel: viewModel)
//            
//            return cell
//        }
//        
//        return dataSource
//    }
//    
//    /// 🔨 Builds a configured BridgedFetchedResultsDelegate for the specific needs of a UITableView
//    ///
//    /// - Returns: Configured BridgedFetchedResultsDelegate
//    func buildBridgedFetchedResultsDelegate() -> BridgedFetchedResultsDelegate? {
//        
//        let delegate = BridgedFetchedResultsDelegate(
//            willChangeContent: { [unowned self] (controller) in
//                self.tableView.beginUpdates()
//                
//                self.willChangeContent?(controller)
//            },
//            didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) in
//                
//                switch changeType {
//                case .insert:
//                    self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//                case .delete:
//                    self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//                default:
//                    break
//                }
//                
//                self.didChangeSection?(controller, sectionInfo, sectionIndex, changeType)
//            },
//            didChangeObject: { [unowned self] (controller, anyObject, indexPath, changeType, newIndexPath) in
//                
//                switch changeType {
//                case .insert:
//                    if let insertIndexPath = newIndexPath {
//                        self.tableView.insertRows(at: [insertIndexPath], with: .fade)
//                    }
//                case .delete:
//                    if let deleteIndexPath = indexPath {
//                        self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
//                    }
//                case .update:
//                    if let indexPath = indexPath,
//                        let tableView = self.dataListView,
//                        let cell = tableView.cellForRow(at: indexPath) as? CellView,
//                        let entity = anyObject as? Entity {
//                        
//                        let viewModel = self.buildViewModel(withEntity: entity)
//                        cell.configure(withModel: viewModel)
//                    }
//                case .move:
//                    if let deleteIndexPath = indexPath {
//                        self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
//                    }
//                    
//                    if let insertIndexPath = newIndexPath {
//                        self.tableView.insertRows(at: [insertIndexPath], with: .fade)
//                    }
//                }
//                
//                self.didChangeObject?(controller, anyObject, indexPath, changeType, newIndexPath)
//            },
//            didChangeContent: { [unowned self] (controller) in
//                
//                self.tableView.endUpdates()
//                
//                self.didChangeContent?(controller)
//        })
//        
//        return delegate
//    }
//    
//}
//
//extension CoreDataEntityDataHandler where ListDataView == UICollectionView, DataCellView: UICollectionViewCell {
//    
//    private var collectionView: UICollectionView { return dataListView }
//    
//    convenience init(forCollectionView collectionView: UICollectionView) {
//        self.init(forDataView: collectionView)
//        
//        collectionView.dataSource = buildCollectionViewDataSource()
//        bridgedFetchedResultsDelegate = buildBridgedFetchedResultsDelegate()
//        
//        // Keeping reference of data provider to avoid deallocation
//        dataProvider = buildDataProvider()
//    }
//    
//    /// 🔨 Build a data source for the specific need of a UICollectionView
//    /// ℹ️ Keep in mind that the real data is owned by the data provider
//    /// ℹ️ This object will just act as the UICollectionViewDataSource
//    ///
//    /// - Returns: Configured ready to use data source for the related tableView
//    func buildCollectionViewDataSource() -> BridgedDataSource {
//    
//        let dataSource = BridgedDataSource(
//            numberOfSections: { [unowned self] () -> Int in
//                return self.dataProvider!.numberOfSections()
//            },
//            numberOfItemsInSection: { [unowned self] (section) -> Int in
//                return self.dataProvider!.numberOfItems(inSection: section)
//        })
//        
//        dataSource.collectionCellForItemAtIndexPath = { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
//            
//            let entity = self.dataProvider!.item(atIndexPath: indexPath)!
//            let viewModel = self.buildViewModel(withEntity: entity)
//            let cell = collectionView.cellForItem(at: indexPath) as! CellView
//            cell.configure(withModel: viewModel)
//            
//            return cell
//        }
//        
////        dataSource.collectionSupplementaryViewAtIndexPath = { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
////            var item: SupplementaryConfig.Item?
////            if indexPath.section < self.dataSource.numberOfSections() {
////                if indexPath.item < self.dataSource.numberOfItems(inSection: indexPath.section) {
////                    item = self.dataSource.item(atIndexPath: indexPath)
////                }
////            }
////            return self.supplementaryConfig.supplementaryViewFor(item: item,
////                                                                 kind: kind,
////                                                                 collectionView: collectionView,
////                                                                 indexPath: indexPath)
////        }
//        
//        return dataSource
//    }
//    
//    /// 🔨 Builds a configured BridgedFetchedResultsDelegate for the specific needs of a UITableView
//    ///
//    /// - Returns: Configured BridgedFetchedResultsDelegate
//    func buildBridgedFetchedResultsDelegate() -> BridgedFetchedResultsDelegate? {
//        let delegate = BridgedFetchedResultsDelegate(
//            willChangeContent: { [unowned self] (controller) in
//                
//                self.sectionChanges.removeAll()
//                self.objectChanges.removeAll()
//                
//                self.willChangeContent?(controller)
//            },
//            didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) in
//                
//                let section = IndexSet(integer: sectionIndex)
//                self.sectionChanges.append { [unowned self] in
//                    switch changeType {
//                    case .insert:
//                        self.collectionView.insertSections(section)
//                    case .delete:
//                        self.collectionView.deleteSections(section)
//                    default:
//                        break
//                    }
//                }
//                
//                self.didChangeSection?(controller, sectionInfo, sectionIndex, changeType)
//            },
//            didChangeObject: { [unowned self] (controller, anyObject, indexPath: IndexPath?, changeType, newIndexPath: IndexPath?) in
//                
//                switch changeType {
//                case .insert:
//                    if let insertIndexPath = newIndexPath {
//                        self.objectChanges.append { [unowned self] in
//                            self.collectionView.insertItems(at: [insertIndexPath])
//                        }
//                    }
//                case .delete:
//                    if let deleteIndexPath = indexPath {
//                        self.objectChanges.append { [unowned self] in
//                            self.collectionView.deleteItems(at: [deleteIndexPath])
//                        }
//                    }
//                case .update:
//                    if let indexPath = indexPath {
//                        self.objectChanges.append { [unowned self] in
//                            if let entity = anyObject as? DataEntity,
//                                let cell = self.collectionView.cellForItem(at: indexPath) as? DataCellView {
//                                
//                                let viewModel = self.buildViewModel(withEntity: entity)
//                                cell.configure(withModel: viewModel)
//                            }
//                        }
//                    }
//                case .move:
//                    if let old = indexPath, let new = newIndexPath {
//                        self.objectChanges.append { [unowned self] in
//                            self.collectionView.deleteItems(at: [old])
//                            self.collectionView.insertItems(at: [new])
//                        }
//                    }
//                }
//                
//                self.didChangeObject?(controller, anyObject, indexPath, changeType, newIndexPath)
//            },
//            didChangeContent: { [unowned self] (controller) in
//                
//                self.collectionView.performBatchUpdates({ [weak self] in
//                    // apply object changes
//                    self?.objectChanges.forEach { $0() }
//                    
//                    // apply section changes
//                    self?.sectionChanges.forEach { $0() }
//                    
//                    }, completion: { [weak self] finished in
////                        self?.reloadSupplementaryViewsIfNeeded()
//                })
//                
//                self.didChangeContent?(controller)
//        })
//        
//        return delegate
//    }
//    
//}
