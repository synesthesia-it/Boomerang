//
//  ElementSize.Implementations.swift
//  CoreUI
//
//  Created by Stefano Mondino on 10/01/21.
//

import CoreGraphics
import Foundation

extension Size {

    struct AspectRatio: GridElementSize {
        let aspectRatio: CGFloat
        let itemsPerLine: Int
        init(aspectRatio: CGFloat, itemsPerLine: Int) {
            self.aspectRatio = aspectRatio
            self.itemsPerLine = itemsPerLine
        }

        func size(for parameters: ContainerProperties) -> CGSize? {
            if let width = parameters.maximumWidth {
                let height = width / aspectRatio
                return CGSize(width: width, height: height)
            }
            if let height = parameters.maximumHeight {
                let width = height * aspectRatio
                return CGSize(width: width, height: height)
            }
            // Almost impossible
            return .zero
        }
    }

    struct Container: ElementSize {
        var itemsPerLine: Int { 1 }

        init() {}

        func size(for parameters: ContainerProperties) -> CGSize? {
            parameters.containerBounds
        }
    }

    struct FixedDimension: GridElementSize {
        var itemsPerLine: Int
        let width: CGFloat?
        let height: CGFloat?
        init(width: CGFloat, itemsPerLine: Int) {
            self.width = width
            height = nil
            self.itemsPerLine = itemsPerLine
        }

        init(height: CGFloat, itemsPerLine: Int) {
            self.height = height
            width = nil
            self.itemsPerLine = itemsPerLine
        }

        func size(for parameters: ContainerProperties) -> CGSize? {
            if let width = self.width {
                return CGSize(width: width, height: parameters.containerBounds.height)
            } else if let height = self.height {
                return CGSize(width: parameters.containerBounds.width, height: height)
            } else {
                return parameters.containerBounds
            }
        }
    }

    struct Configurable: GridElementSize {
        let itemsPerLine: Int
        let closure: (ContainerProperties) -> CGSize?
        init(itemsPerLine: Int = 1, closure: @escaping (ContainerProperties) -> CGSize?) {
            self.itemsPerLine = itemsPerLine
            self.closure = closure
        }

        func size(for properties: ContainerProperties) -> CGSize? {
            closure(properties)
        }
    }
}
