//
//  Utils.swift
//  Pods
//
//  Created by Winann on 11/09/2017.
//
//

import Foundation
import ObjectiveC
private var layerBorderColor = UIColor.gray

extension UIView {
    
    var xibBorderColorWithUIColor: UIColor! {
        get {
            return (objc_getAssociatedObject(self, &layerBorderColor) as? UIColor)
        }
        set {
            objc_setAssociatedObject(self, &layerBorderColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.layer.borderColor = xibBorderColorWithUIColor.cgColor
        }
    }
}

