//
//  SortableListCoordinator.swift
//  SortableList
//
//  Created by Tad Scritchfield on 1/4/21.
//

import Foundation
import CoreGraphics

// I don't think this method will work because the list items need to know about
// the other lists in some way... or something like that. I could instead make this
// coordinator manage the active state of all list views similar to my previous try.

enum ActionType {
    case ADD
    case REMOVE
}

class SortableListCoordinator<I> {
    typealias Handler = (I, CGPoint, ActionType) -> Void
    private var listHandlers: [UUID: Handler] = [:]
    
    public func register(_ id: UUID, handler: @escaping Handler) {
        listHandlers[id] = handler
    }
    
    public func deregister(_ id: UUID) {
        listHandlers.removeValue(forKey: id)
    }
    
    public func moveItem(_ item: I, fromList: UUID, atIndex: Int, toXY toXYScreenPostion: CGPoint) {
        for (id, handler) in listHandlers {
            handler(item, toXYScreenPostion, id == fromList ? ActionType.REMOVE : ActionType.ADD)
        }
    }
}
