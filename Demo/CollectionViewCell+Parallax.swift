//
//  CollectionViewCell+Parallax.swift
//  Demo
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
#if os(tvOS)
import ParallaxView

class CustomContentCollectionViewCell: ParallaxCollectionViewCell, ContentCollectionViewCellType {
    
    fileprivate var widthToHeightRatio = CGFloat(0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    func sharedInit() {
        
        // Here you can configure custom properties for parallax effect
        cornerRadius = 8
        
        parallaxEffectOptions.glowAlpha = 0.4
        parallaxEffectOptions.shadowPanDeviation = 10
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleX = CGFloat(Double.pi/4/30)
        parallaxEffectOptions.parallaxMotionEffect.viewingAngleY = CGFloat(Double.pi/4/30)
        parallaxEffectOptions.parallaxMotionEffect.panValue = CGFloat(5)
        
        // You can customise parallax view standard behaviours using parallaxViewActions property.
        // Do not forget to use weak self if needed to void retain cycle
        parallaxViewActions.setupUnfocusedState = { (view) -> Void in
            view.transform = CGAffineTransform.identity
            
            view.layer.shadowOffset = CGSize(width: 0, height: 10)
            view.layer.shadowOpacity = 0.3
            view.layer.shadowRadius = 5
            view.layer.shadowColor = UIColor.black.cgColor
        }
        
        parallaxViewActions.setupFocusedState = { [weak self] (view) -> Void in
            guard let _self = self else { return }
            view.transform = CGAffineTransform(scaleX: 1.08, y: _self.widthToHeightRatio)
            
            view.layer.shadowOffset = CGSize(width: 0, height: 20)
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 15
            view.layer.shadowColor = view.backgroundColor?.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        widthToHeightRatio = round(((bounds.width * 0.08 + bounds.height)/bounds.height)*100)/100
    }
    public weak var internalView: UIView?
    ///Constraints between cell and inner view.
    public var insetConstraints: [NSLayoutConstraint] = []
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        (internalView as? CollectionViewCellContained)?.apply(layoutAttributes)
    }
    
//    open override var canBecomeFocused: Bool {
//        return internalView?.canBecomeFocused ?? super.canBecomeFocused
//    }
//    open override var preferredFocusEnvironments: [UIFocusEnvironment] {
//        return internalView?.preferredFocusEnvironments ?? super.preferredFocusEnvironments
//    }
//    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        return internalView?.didUpdateFocus(in:context, with: coordinator) ?? super.didUpdateFocus(in: context, with: coordinator)
//    }
}


#elseif os(iOS)

typealias CustomContentCollectionViewCell = ContentCollectionViewCell
#endif
