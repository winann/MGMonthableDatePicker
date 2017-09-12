//
//  MonthOrDayStyleDatePickable.swift
//  MogoPartner
//
//  Created by Winann on 09/08/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

public protocol MonthOrDayStyleDatePickable {
    
    var dateSelectView: MGMonthableDatePicker { get }
    func selectDate(_ callBack: @escaping (Bool, Bool?, Date?) -> Void)
}

extension MonthOrDayStyleDatePickable {
    public func selectDate(_ callBack: @escaping (Bool, Bool?, Date?) -> Void) {
        
        addSelectView()
        dateSelectView.selectResult = callBack
        dateSelectView.show()
    }
    public func addSelectView() {
        var addedView: UIView? = nil
        if let view = self as? UIView {
            if let _ = dateSelectView.superview {
                return
            } else if let vc = view.viewController() {
                addedView = vc.view
            }
        } else if let vc = self as? UIViewController {
            if let _ = dateSelectView.superview {
                return
            }
            addedView = vc.view
        } else {
            return
        }
        
        guard let superView = addedView else { return }
        
        superView.addSubview(dateSelectView)
        dateSelectView.configCurrentDate()
        dateSelectView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: dateSelectView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: dateSelectView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: dateSelectView, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: dateSelectView, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1.0, constant: 0)
        superView.addConstraints([top, leading, bottom, trailing])
    }
    
}
