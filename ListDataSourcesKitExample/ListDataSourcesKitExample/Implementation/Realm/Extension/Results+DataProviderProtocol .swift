//
//  Results+DataProviderProtocol .swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import RealmSwift
import ListDataSourcesKit

extension Results: DataProviderProtocol {
    
    /// :nodoc:
    public typealias Item = Results.Element
    
    /// :nodoc:
    public func numberOfSections() -> Int {
        return 1
    }
    
    /// :nodoc:
    public func numberOfItems(inSection section: Int) -> Int {
        guard section < numberOfSections() else { return 0 }
        return self.count
    }
    
    /// :nodoc:
    public func items(inSection section: Int) -> [Item]? {
        guard section < numberOfSections() else { return nil }
        return self.compactMap { return $0 }
    }
    
    /// :nodoc:
    public func item(atRow row: Int, inSection section: Int) -> Item? {
        
        guard section < numberOfSections() else { return nil }
        guard let objects = items(inSection: section) else { return nil }
        guard row < objects.count else { return nil }
        
        return objects[row]
    }
    
    /// :nodoc:
    public func headerTitle(inSection section: Int) -> String? {
        guard section < numberOfSections() else { return nil }
        return nil
    }
    
    /// :nodoc:
    public func footerTitle(inSection section: Int) -> String? {
        return nil
    }
}

extension Results {
    
    /// :nodoc:
    public func item(atIndexPath indexPath: IndexPath) -> Item? {
        return item(atRow: indexPath.row, inSection: indexPath.section)
    }
}
