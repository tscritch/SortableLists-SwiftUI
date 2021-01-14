//
//  ContentView.swift
//  SortableList
//
//  Created by Tad Scritchfield on 1/4/21.
//

import SwiftUI

struct ContentView: View {
    var listCoordinator = Coordinator<Item>()
    var body: some View {
        SortableListSketch(listCoordinator)
//        GeometryTest()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
