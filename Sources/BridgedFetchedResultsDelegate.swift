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

import CoreData
import Foundation

/// This class is responsible for implementing the `NSFetchedResultsControllerDelegate` protocol.
/// It avoids making `FetchedResultsDelegateProvider` inherit from `NSObject`, and keeps classes small and focused.
@objc
public final class BridgedFetchedResultsDelegate: NSObject {
    
    //****************************************************
    // MARK: - Closure TypeAlias Definitions
    //****************************************************
    
    public typealias WillChangeContentHandler = (NSFetchedResultsController<NSFetchRequestResult>) -> Void
    public typealias DidChangeSectionHandler = (NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsSectionInfo, Int, NSFetchedResultsChangeType) -> Void
    public typealias DidChangeObjectHandler = (NSFetchedResultsController<NSFetchRequestResult>, Any, IndexPath?, NSFetchedResultsChangeType, IndexPath?) -> Void
    public typealias DidChangeContentHandler = (NSFetchedResultsController<NSFetchRequestResult>) -> Void
    
    //****************************************************
    // MARK: - Closures
    //****************************************************
    
    let willChangeContent: WillChangeContentHandler
    let didChangeSection: DidChangeSectionHandler
    let didChangeObject: DidChangeObjectHandler
    let didChangeContent: DidChangeContentHandler
    
    //****************************************************
    // MARK: - Initialization
    //****************************************************
    
    public init(willChangeContent: @escaping WillChangeContentHandler, didChangeSection: @escaping DidChangeSectionHandler, didChangeObject: @escaping DidChangeObjectHandler, didChangeContent: @escaping DidChangeContentHandler) {
        
        self.willChangeContent = willChangeContent
        self.didChangeSection = didChangeSection
        self.didChangeObject = didChangeObject
        self.didChangeContent = didChangeContent
    }
}

extension BridgedFetchedResultsDelegate: NSFetchedResultsControllerDelegate {
    
    @objc public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChangeContent(controller)
    }
    
    @objc public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        didChangeSection(controller, sectionInfo, sectionIndex, type)
    }
    
    @objc public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        didChangeObject(controller, anObject, indexPath, type, newIndexPath)
    }
    
    @objc public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChangeContent(controller)
    }
}
