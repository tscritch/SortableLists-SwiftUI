//
//  Sketch.swift
//  SortableList
//
//  Created by Tad Scritchfield on 1/5/21.
//

import SwiftUI
import CoreGraphics

class Coordinator<I> {
    typealias UpdateHandler = (CGPoint) -> Void
    typealias EndHandler = (CGPoint) -> Bool
    
    private var registeredLists: [UUID: (UpdateHandler, EndHandler)] = [:]
    
    var activeDraggingItem: I?
    var originList: UUID?
    
    
    public func register(_ id: UUID, handlers: (UpdateHandler, EndHandler)) {
        registeredLists[id] = handlers
    }
    
    public func deregister(_ id: UUID) {
        registeredLists.removeValue(forKey: id)
    }
    
    public func dragStart(listId: UUID, item: I) {
        originList = listId
        activeDraggingItem = item
    }
    
    public func dragUpdate(_ position: CGPoint) {
        for (_, handlers) in registeredLists {
            handlers.0(position)
        }
    }
    
    public func dragEnd(_ position: CGPoint) {
        for (id, handlers) in registeredLists {
            if handlers.1(position) {
                listAcceptsDraggedItem(listToMoveTo: id)
                originList = nil
                activeDraggingItem = nil
                return
            }
        }
    }
    
    // need some way to confirm the move happened
    private func listAcceptsDraggedItem(listToMoveTo: UUID) {
        // call handler in new list to add activeDragging item
        // call handler in origin list to remove item from list
        // might be something weird with memory handling here
    }
}

class StupidSize: ObservableObject {
    @Published var size: CGSize = .zero
    @Published var position: CGPoint = .zero
}

struct SortableListSketch: View {
    public let id = UUID()
    private var coordinator: Coordinator<Item>
    
    init(_ coordinator: Coordinator<Item>) {
        self.coordinator = coordinator
        self.coordinator.register(self.id, handlers: (self.handleDragUpdate, self.handleDragEnd))
    }
    
    var itemSpacing: CGFloat = 0
    
    @State var hasDragStarted = false
    @State var wasDragCanceled = false
    @State var itemIndexDragging: Int?
    
    // this gets updated from the geometry reader to get the global position in the view
    @State private var ghostItemGlobalFrame: CGRect = .zero
    // this get updated from the drag event to position it and in turn read the global positon
    @State private var ghostItemTranslation: CGSize = .zero
    
    @State var ghostItemSize: CGSize = .zero
    @State var ghostItemPosition: CGPoint = .zero
    
    @State var list: [Item] = [
        Item(text: "Item A"),
        Item(text: "Item B"),
        Item(text: "Item C"),
        Item(text: "Item D"),
        Item(text: "Item E"),
        Item(text: "Item F"),
        Item(text: "Item G"),
    ]
    
    @State var listOfSizes: [StupidSize] = [
        StupidSize(),
        StupidSize(),
        StupidSize(),
        StupidSize(),
        StupidSize(),
        StupidSize(),
        StupidSize(),
    ]
    
    var body: some View {
        // create ghost item with geometry reader to keep track of its global position
        GeometryReader { viewGeometry in
            ZStack(alignment: .top) {
                VStack(spacing: itemSpacing) {
                    ForEach(list.indices) { i in
                        ItemView(text: list[i].text, size: $listOfSizes[i].size, position: $listOfSizes[i].position)
    //                            .padding(0)
                            .frame(height: i % 2 == 0 ? 50 : 100)
                            .background(Color.blue)
                    }
                }
                .gesture(DragGesture()
                            .onChanged { value in
                                if wasDragCanceled { return }
                                if !hasDragStarted {
                                    let itemIndex = getItemIndexToDrag(dragPosition: value.startLocation)
                                    print(itemIndex)
                                    if itemIndex == -1 {
                                        wasDragCanceled = true
                                        return
                                    }
                                    let foundListItem = list[itemIndex]
                                    coordinator.dragStart(listId: id, item: foundListItem)
                                    itemIndexDragging = itemIndex
                                    ghostItemSize = listOfSizes[itemIndex].size
                                    ghostItemPosition = listOfSizes[itemIndex].position
                                    hasDragStarted = true
                                }
                                let globalPosition = CGPoint(x: ghostItemGlobalFrame.origin.x + value.translation.width, y: ghostItemGlobalFrame.origin.y + value.translation.height)
                                coordinator.dragUpdate(globalPosition)
                                ghostItemTranslation = value.translation
                            }
                            .onEnded { value in
                                if wasDragCanceled {
                                    hasDragStarted = false
                                    wasDragCanceled = false
                                    return
                                }
                                let globalPosition = CGPoint(x: ghostItemGlobalFrame.midX, y: ghostItemGlobalFrame.midY)
                                coordinator.dragEnd(globalPosition)
                                hasDragStarted = false
                                wasDragCanceled = false
                                itemIndexDragging = nil
                                ghostItemPosition = .zero
                                ghostItemTranslation = .zero
                                ghostItemGlobalFrame = .zero
                            }
                )
                
                renderGhostItem()
                    .frame(height: ghostItemSize.height)
                    .background(Color.orange)
                    .opacity(0.8)
                    .position(x: ghostItemPosition.x + (ghostItemSize.width / 2), y: ghostItemPosition.y - (ghostItemSize.height * 0) + (viewGeometry.frame(in: .local).minY))
                    .offset(y: ghostItemTranslation.height)
                
            }
        }
        
        Text("\(ghostItemPosition.y)")
    }
    
    private func handleDragUpdate(_ updatedPoint: CGPoint) {
        // check if updated point is in list view @todo will need list global location
//        print(updatedPoint)
    }
    
    private func handleDragEnd(_ endPoint: CGPoint) -> Bool {
        // check if end point is in list view @todo will need list global location
//        if true {
//            coordinator.listAcceptsDraggedItem(listToMoveTo: id)
//        }
        return false
    }
    
    func renderGhostItem() -> some View {
        let item = Item(text: itemIndexDragging != nil ? list[itemIndexDragging!].text : "no item")
        return ItemView(text: item.text, size: Binding.constant(CGSize.zero), position: Binding.constant(CGPoint.zero))
    }
    
    func getItemIndexToDrag(dragPosition: CGPoint) -> Int {
        var itemHeightLocation: CGFloat = 0
        print("drag pos: ", dragPosition)
        // @todo add ability to ignore itemSpacing
        for (index, item) in listOfSizes.enumerated() {
            print("item height:", item.size, "location: ", itemHeightLocation)
            if (dragPosition.y > itemHeightLocation && dragPosition.y < itemHeightLocation + item.size.height) {
                // we have started the drag on this item and we can return the index
                return index
            }
            itemHeightLocation = itemHeightLocation + item.size.height
        }
        // for now since there is no drag cancelation we will return -1
        return -1
    }
    
    public func addItem(_ item: Item, at atIndex: Int) {
        print("add item called with: ", item, atIndex)
    }
}

struct Item: Identifiable, ListItem {
    var id = UUID()
    var text: String
}

struct ItemView: View {
    var text: String
    
    @Binding var size: CGSize
    @Binding var position: CGPoint
    
    var body: some View {
        GeometryReader { geometry in
            makeView(geometry)
        }
    }
    
    func makeView(_ geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.size = geometry.size
            self.position = geometry.frame(in: .global).origin
        }
        
        return Text("\(self.text)")
    }
}
