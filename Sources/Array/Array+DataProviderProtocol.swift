//
//  Array+DataProviderProtocol.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import Foundation

extension Array: DataProviderProtocol {
    
    public typealias Item = Element
    
    public func items(inSection section: Int) -> [Item]? {
        guard section == 0 else { fatalError("❌ There is no sections in ArrayDataProvider") }
        return self
    }
    
    public func numberOfSections() -> Int {
        return 1
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        return self.count
    }
    
    public func item(atRow row: Int, inSection section: Int) -> Item? {
        guard section == 0 else { fatalError("❌ There is no sections in ArrayDataProvider") }
        return self[row]
    }
    
    public func headerTitle(inSection section: Int) -> String? {
        return nil
    }
    
    public func footerTitle(inSection section: Int) -> String? {
        return nil
    }
}
