//
//  Collection.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import Foundation

extension Collection where Index == Int, Iterator.Element: Collection, Iterator.Element.Index == Int {
    func object(from indexPath: IndexPath) -> Iterator.Element.Iterator.Element {
        return self[indexPath.section][indexPath.row]
    }
}
