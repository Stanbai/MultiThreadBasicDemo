//
//  Item.swift
//  NSOperation
//
//  Created by Stan on 2017-07-24.
//  Copyright © 2017 stan. All rights reserved.
//

import Foundation

class Item {
    let count: Int
    
    init(number: Int) {
       count = number
    }
    
   static func creatItems(count: Int) -> [Item] {
        var items = [Item]()
        
        for index in 1...count {
            items.append(Item(number: index))
        }
        return items
    }
    
    func imageUrl() -> URL? {
        return URL(string:"https://placeholdit.imgix.net/~text?txtsize=33&txt=image+\(count)&w=300&h=300")
    }
}
