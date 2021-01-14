//
//  HScreenSize.swift
//  SortableList
//
//  Created by Tad Scritchfield on 1/13/21.
//

import UIKit

class HScreenSize {
//    #if os(watchOS)
//    static var deviceWidth:CGFloat = WKInterfaceDevice.current().screenBounds.size.width
//    #if os(iOS)
    static var deviceSize: CGSize = UIScreen.main.bounds.size
//    #elseif os(macOS)
//    static var deviceSize: CGSize = NSScreen.main.bounds.size
//    #endif
}
