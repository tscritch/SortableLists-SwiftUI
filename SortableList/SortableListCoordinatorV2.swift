//
//  SortableListCoordinatorV2.swift
//  SortableList
//
//  Created by Tad Scritchfield on 1/5/21.
//

import SwiftUI

struct SortableListCoordinatorV2: View {
    
    @State var itemDragging: Int?
    @State var dragAmount: CGSize?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SortableListCoordinatorV2_Previews: PreviewProvider {
    static var previews: some View {
        SortableListCoordinatorV2()
    }
}
