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
    
    func addConstraintsToPinHorizontalEdgesToSuperView(with padding: CGFloat = 0) {
        prepareForConstraints()
        self.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[view]-(padding)-|",
                                                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                                                      metrics: ["padding":padding],
                                                                                      views: ["view":self]))
    }
    
    func addConstraintsToPinVerticalEdgesToSuperView(with padding: CGFloat = 0) {
        prepareForConstraints()
        self.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[view]-(padding)-|",
                                                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                                                      metrics: ["padding":padding],
                                                                                      views: ["view":self]))
    }
    
    func addConstraintsToCenterVertically() {
        prepareForConstraints()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .centerY,
                                                         multiplier: 1.0, constant: 0))
    }
    
    func addConstraintsToCenterHorizontally() {
        prepareForConstraints()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .centerX,
                                                         multiplier: 1.0, constant: 0))
    }
    
    func addConstraintsToPinWidthToSuperview() {
        prepareForConstraints()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .width,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .width,
                                                         multiplier: 1.0, constant: 0))
    }
    
    func addConstraintsToPinHeightToSuperview() {
        prepareForConstraints()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .height,
                                                         multiplier: 1.0, constant: 0))
    }
    @discardableResult
    func addConstraintsToPinLeadingToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .leading,
                                            multiplier: 1, constant: constant)
        
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinTrailingToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .trailing,
                                            multiplier: 1, constant: -constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinTopToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .top,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinBottomToSuperview(constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .bottom,
                                            multiplier: 1, constant: -constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinTop(to view:UIView,constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinLeft(to view:UIView,constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .right,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinRight(to view:UIView,constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .left,
                                            multiplier: 1, constant: -constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    @discardableResult
    func addConstraintsToPinBottom(to view:UIView,constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .top,
                                            multiplier: 1, constant: -constant)
        self.superview!.addConstraint(constraint)
        return constraint
    }
    
    
    func addConstraintsToFillSuperview(withPadding padding: CGFloat = 0) {
        prepareForConstraints()
        addConstraintsToPinHorizontalEdgesToSuperView(with: padding)
        addConstraintsToPinVerticalEdgesToSuperView(with: padding)
    }

    private func prepareForConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        if superview == nil {
            assert(false, "You need to have a superview before you can add contraints")
        }
    }
    
    
    
    
    
}
