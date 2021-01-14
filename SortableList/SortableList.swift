//
//  SortableList.swift
//  SortableList
//  This view will keep track of what items are
//  in its own list and the operations to remove,
//  add, and move items in the list.
//
//  Created by Tad Scritchfield on 1/4/21.
//

import SwiftUI

protocol ListItem {
    var id: UUID { get }
}

struct SortableList: View {
    public let id = UUID()
    
    @State var list: [Item] = [
        Item(text: "Item A"),
        Item(text: "Item B"),
        Item(text: "Item C"),
        Item(text: "Item D"),
        Item(text: "Item E"),
        Item(text: "Item F"),
        Item(text: "Item G"),
    ]
    
    var body: some View {
        VStack {
            ForEach(list.indices) { i in
                Text(list[i].text)
            }
        }
    }
    
    public func addItem(_ item: Item, at atIndex: Int) {
        print("add item called with: ", item, atIndex)
    }
}

struct SortableList_Previews: PreviewProvider {
    static var previews: some View {
        SortableList()
    }
}

