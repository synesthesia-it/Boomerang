//
//  ElementSize.swift
//  Skeleton
//
//  Created by Stefano Mondino on 09/01/21.
//

import Foundation
import CoreGraphics

#if os(macOS)
import AppTrackingTransparency
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

public protocol ElementSize {
    func size(for parameters: Size.ContainerProperties) -> CGSize?
}

public protocol GridElementSize: ElementSize {
    var itemsPerLine: Int { get }
}

public protocol WithElementSize {
    var elementSize: ElementSize { get }
}

public enum Size {
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

        public let containerBounds: CGSize
        public let containerInsets: EdgeInsets
        public let maximumWidth: CGFloat?
        public let maximumHeight: CGFloat?
    }

    public struct SectionProperties {
        public static let zero = SectionProperties()
        public let insets: EdgeInsets
        public let lineSpacing: CGFloat
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
    
    static func zero() -> ElementSize {
        fixed(size: CGSize.zero)
    }
    
    static func fixed(size: CGSize) -> ElementSize {
        Configurable(itemsPerLine: 1) { _ in size }
    }

    static func fixed(width: CGFloat, itemsPerLine: Int = 1) -> ElementSize {
        FixedDimension(width: width, itemsPerLine: itemsPerLine)
    }

    static func fixed(height: CGFloat, itemsPerLine: Int = 1) -> ElementSize {
        FixedDimension(height: height, itemsPerLine: itemsPerLine)
    }

    static func aspectRatio(_ aspectRatio: CGFloat, itemsPerLine: Int = 1) -> ElementSize {
        AspectRatio(aspectRatio: aspectRatio, itemsPerLine: itemsPerLine)
    }

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

    static func automatic(itemsPerLine: Int = 1) -> ElementSize {
        Configurable(itemsPerLine: itemsPerLine) { _ in nil }
    }

    static func custom(itemsPerLine: Int = 1, closure: @escaping (ContainerProperties) -> CGSize?) -> ElementSize {
        Configurable(itemsPerLine: itemsPerLine, closure: closure)
    }
}
