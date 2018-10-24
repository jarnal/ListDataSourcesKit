//
//  Array+DataProviderProtocol.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import Foundation
import ListDataSourcesKit

extension Array: DataProviderProtocol where Iterator.Element: Collection, Iterator.Element.Index == Int {
    
    public typealias Item = Iterator.Element.Iterator.Element
    
    public func items(inSection section: Int) -> [Item]? {
        return self[section] as? [Element.Element]
    }
    
    public func numberOfSections() -> Int {
        return self.count
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        let sectionItems = self[section]
        return sectionItems.count
    }
    
    public func item(atRow row: Int, inSection section: Int) -> Item? {
        return self.object(from: IndexPath(item: row, section: section))
    }
    
    public func headerTitle(inSection section: Int) -> String? {
        return ""
    }
    
    public func footerTitle(inSection section: Int) -> String? {
        return ""
    }
}
