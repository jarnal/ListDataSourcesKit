//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import Foundation
import UIKit

/// This class is responsible for implementing the `UICollectionViewDataSource` and `UITableViewDataSource` protocols.
@objc public final class BridgedDataSource: NSObject {
    
    //****************************************************
    // MARK: - Closure TypeAlias Definitions
    //****************************************************
    
    public typealias NumberOfSectionsHandler = () -> Int
    public typealias NumberOfItemsInSectionHandler = (Int) -> Int
    
    public typealias CollectionCellForItemAtIndexPathHandler = (UICollectionView, IndexPath) -> UICollectionViewCell
    public typealias CollectionSupplementaryViewAtIndexPathHandler = (UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    public typealias TableCellForRowAtIndexPathHandler = (UITableView, IndexPath) -> UITableViewCell
    public typealias TableTitleForHeaderInSectionHandler = (Int) -> String?
    public typealias TableTitleForFooterInSectionHandler = (Int) -> String?
    
    public typealias TableCanEditHandler = (UITableView, IndexPath) -> Bool
    public typealias TableCommitEditingStyleHandler = (UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void
    
    //****************************************************
    // MARK: - Closures
    //****************************************************
    
    let numberOfSections: NumberOfSectionsHandler
    let numberOfItemsInSection: NumberOfItemsInSectionHandler
    
    public var collectionCellForItemAtIndexPath: CollectionCellForItemAtIndexPathHandler?
    public var collectionSupplementaryViewAtIndexPath: CollectionSupplementaryViewAtIndexPathHandler?
    
    public var tableCellForRowAtIndexPath: TableCellForRowAtIndexPathHandler?
    public var tableTitleForHeaderInSection: TableTitleForHeaderInSectionHandler?
    public var tableTitleForFooterInSection: TableTitleForFooterInSectionHandler?
    
    public var tableCanEditRow: TableCanEditHandler?
    public var tableCommitEditingStyleForRow: TableCommitEditingStyleHandler?
    
    //****************************************************
    // MARK: - Initialization
    //****************************************************
    
    /// 🏭 Initialization of data source
    ///
    /// - Parameters:
    ///   - numberOfSections: block returning the number of sections
    ///   - numberOfItemsInSection: block returning the number of items in a section
    public init(numberOfSections: @escaping NumberOfSectionsHandler, numberOfItemsInSection: @escaping NumberOfItemsInSectionHandler) {
        self.numberOfSections = numberOfSections
        self.numberOfItemsInSection = numberOfItemsInSection
    }
}

extension BridgedDataSource: UICollectionViewDataSource {
   
    @objc public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCellForItemAtIndexPath!(collectionView, indexPath)
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionSupplementaryViewAtIndexPath!(collectionView, kind, indexPath)
    }
}

extension BridgedDataSource: UITableViewDataSource {
    
    @objc public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    @objc public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }
    
    @objc public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCellForRowAtIndexPath!(tableView, indexPath)
    }
    
    @objc public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let closure = tableTitleForHeaderInSection {
            return closure(section)
        }
        return nil
    }
    
    @objc public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let closure = tableTitleForFooterInSection {
            return closure(section)
        }
        return nil
    }
    
    @objc public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let closure = tableCanEditRow {
            return closure(tableView, indexPath)
        }
        return false
    }
    
    @objc public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableCommitEditingStyleForRow?(tableView, editingStyle, indexPath)
    }
}
