//
//  Utilities.swift
//  Boomerang
//
//  Created by Stefano Mondino on 25/06/17.
//
//

import UIKit
 extension UIView {
    @discardableResult
    func addAndFitSubview(_ subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        addSubview(subview)
        return subview.fitInSuperview(with: insets)
    }
    @discardableResult
    func fitInSuperview(with insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("fitInSuperview was called but view was not in a view hierarchy.")
            return []
        }
        
        let applyInset: (NSLayoutAttribute, UIEdgeInsets) -> CGFloat = {
            switch $0 {
            case .top: return $1.top
            case .bottom: return -$1.bottom
            case .left: return $1.left
            case .right: return -$1.right
            default:
                return 0
            }
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [NSLayoutAttribute.top, .left, .right, .bottom]
        let constraints = attributes.map {
            return NSLayoutConstraint(item: self,
                                      attribute: $0,
                                      relatedBy: .equal,
                                      toItem: superview,
                                      attribute: $0,
                                      multiplier: 1,
                                      constant: applyInset($0, insets))
        }
         superview.addConstraints(constraints)
        return constraints
    }
}
