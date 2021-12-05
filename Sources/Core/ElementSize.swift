//
//  ElementSize.swift
//  Skeleton
//
//  Created by Stefano Mondino on 09/01/21.
//

import Foundation
import CoreGraphics

#if os(macOS)
public typealias EdgeInsets = NSEdgeInsets
public extension EdgeInsets {
    static var zero: EdgeInsets {
        NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
#else
import UIKit
public typealias EdgeInsets = UIEdgeInsets
#endif

/// An object representing a size.
public protocol ElementSize {
    func size(for parameters: Size.ContainerProperties) -> CGSize?
}

/// A special element size for elements put in grids, like UICollectionViews.
public protocol GridElementSize: ElementSize {
    /// Defines how many elements should be placed on the same line in a grid.
    /// If flow is vertical, this represents columns on each line.
    var itemsPerLine: Int { get }
}

/// An object (usually a `ViewModel`) that can be graphically represented with a "size" counterpart.
public protocol WithElementSize {
    var elementSize: ElementSize { get }
}

public enum Size {
    /// An object representing properties for a container like a collection view
    public struct ContainerProperties {
        public init(containerBounds: CGSize,
                    containerInsets: EdgeInsets = .zero,
                    maximumWidth: CGFloat?,
                    maximumHeight: CGFloat?) {
            self.containerBounds = containerBounds
            self.maximumWidth = maximumWidth
            self.maximumHeight = maximumHeight
            self.containerInsets = containerInsets
        }
        /// Available container size (the frame of a collection view)
        public let containerBounds: CGSize
        /// Global insets of container (adjustedInsets in collectionView), without the sectionInsets
        public let containerInsets: EdgeInsets
        /// Maximum width available for an item. In a grid, this is the global container width divided by total elements in line (with section insets and inter item spacing already taken into account). Nil when no constraint is available (eg: in an horizontal flow)
        public let maximumWidth: CGFloat?
        /// Maximum height available for an item. In a grid, this is the global container height divided by total elements in line (with section insets and inter item spacing already taken into account). Nil when no constraint is available (eg: in an vertical flow)
        public let maximumHeight: CGFloat?
    }
    
    /// An object representing section properties.
    public struct SectionProperties {
        /// Utility for a zero-valued SectionProperties element
        public static let zero = SectionProperties()
        /// Insets for current section
        public let insets: EdgeInsets
        /// Spacing between each line in current section
        public let lineSpacing: CGFloat
        /// Spacing between every element on the same line in current section
        public let itemSpacing: CGFloat
        public init(insets: EdgeInsets = .zero,
                    lineSpacing: CGFloat = 0,
                    itemSpacing: CGFloat = 0) {
            self.insets = insets
            self.lineSpacing = lineSpacing
            self.itemSpacing = itemSpacing
        }
    }
}

public extension Size {
    /// Element with width and height equal to zero
    static func zero() -> ElementSize {
        fixed(size: CGSize.zero)
    }
    /// Element with a fixed size
    static func fixed(size: CGSize) -> ElementSize {
        Configurable(itemsPerLine: 1) { _ in size }
    }
    /// Element with a fixed width and custom number of elements per line (defaults to 1).
    static func fixed(width: CGFloat, itemsPerLine: Int = 1) -> ElementSize {
        FixedDimension(width: width, itemsPerLine: itemsPerLine)
    }
    /// Element with a fixed height and custom number of elements per line (defaults to 1).
    static func fixed(height: CGFloat, itemsPerLine: Int = 1) -> ElementSize {
        FixedDimension(height: height, itemsPerLine: itemsPerLine)
    }
    /// Element with a fixed aspect ratio and custom number of elements per line (defaults to 1).
    static func aspectRatio(_ aspectRatio: CGFloat, itemsPerLine: Int = 1) -> ElementSize {
        AspectRatio(aspectRatio: aspectRatio, itemsPerLine: itemsPerLine)
    }
    /// Element with a size matching its container. If `useContentInsets` is true, size will take into accounts insets in container. Defaults to false.
    static func container(useContentInsets: Bool = false) -> ElementSize {
        Configurable { params in
            let insets: EdgeInsets = useContentInsets ? params.containerInsets : .zero
            return CGRect(x: insets.left,
                   y: insets.top,
                   width: params.containerBounds.width - insets.left - insets.right,
                   height: params.containerBounds.height - insets.top - insets.bottom)
                .size
        }
    }
    /// Size is automatically calculated according to available space and flow. Can be customize with number of elements per line (defaults to 1).
    static func automatic(itemsPerLine: Int = 1) -> ElementSize {
        Configurable(itemsPerLine: itemsPerLine) { _ in nil }
    }
    /// Size customizable via closure. Elements for every line can be customized (defaults to 1).
    static func custom(itemsPerLine: Int = 1, closure: @escaping (ContainerProperties) -> CGSize?) -> ElementSize {
        Configurable(itemsPerLine: itemsPerLine, closure: closure)
    }
}
