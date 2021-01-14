//
//  GeometryTest.swift
//  SortableList
//
//  Created by Tad Scritchfield on 1/13/21.
//

import SwiftUI

struct GeometryTest: View {
    @State var translation: CGSize = .zero
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .gesture(DragGesture()
                            .onChanged { value in
                                translation = value.translation
                            }
                            .onEnded { value in
                                translation = .zero
                            }
            )
            
            GeometryReader { geo in
                render(geo)
                    .position(x: 10.0, y: translation.height)
//                    .offset(y: translation.height)
            }
        }
    }
    
    func render(_ geometry: GeometryProxy) -> some View {
//        DispatchQueue.main.async {
//
//        }
        let frame = geometry.frame(in: .global)
        print(frame, frame.origin)
        return Rectangle()
    }
}

struct GeometryTest_Previews: PreviewProvider {
    static var previews: some View {
        GeometryTest()
    }
}
