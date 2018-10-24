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

/**
 This protocol unifies `UICollectionView` and `UITableView` by providing a common dequeue method for cells.
 It describes a view that is the "parent" view for a cell.
 For `UICollectionViewCell`, this would be `UICollectionView`.
 For `UITableViewCell`, this would be `UITableView`.
 */
public protocol CellParentViewProtocol {
    
    // MARK: Associated types
    
    /// The type of cell for this parent view.
    associatedtype CellType: UIView
    
    // MARK: Methods
    
    /**
     Returns a reusable cell located by its identifier.
     
     - parameter identifier: The reuse identifier for the specified cell.
     - parameter indexPath:  The index path specifying the location of the cell.
     
     - returns: A valid `CellType` reusable cell.
     */
    func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType
    
    /**
     Returns a reusable supplementary view located by its identifier and kind.
     
     - parameter kind:       The kind of supplementary view to retrieve.
     - parameter identifier: The reuse identifier for the specified view.
     - parameter indexPath:  The index path specifying the location of the supplementary view in the collection view.
     
     - returns: A valid `CellType` reusable view.
     */
    func dequeueReusableSupplementaryViewFor(kind: String, identifier: String, indexPath: IndexPath) -> CellType?
}

extension UICollectionView: CellParentViewProtocol {
    
    /// :nodoc:
    public typealias CellType = UICollectionReusableView
    
    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: String, identifier: String, indexPath: IndexPath) -> CellType? {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}

extension UITableView: CellParentViewProtocol {
    
    /// :nodoc:
    public typealias CellType = UITableViewCell
    
    /// :nodoc:
    public func dequeueReusableCellFor(identifier: String, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    /// :nodoc:
    public func dequeueReusableSupplementaryViewFor(kind: String, identifier: String, indexPath: IndexPath) -> CellType? {
        return nil
    }
}
