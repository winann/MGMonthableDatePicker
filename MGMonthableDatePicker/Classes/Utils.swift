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
    
    ///----------------------
    /// MARK: viewControllers
    ///----------------------
    
    /**
     Returns the UIViewController object that manages the receiver.
     */
    func viewController()->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    var borderColorWithUIColor: UIColor! {
        get {
            return (objc_getAssociatedObject(self, &layerBorderColor) as? UIColor)
        }
        set {
            objc_setAssociatedObject(self, &layerBorderColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.layer.borderColor = borderColorWithUIColor.cgColor
        }
    }
}


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    /// str.substring(with: 5..<6)
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
