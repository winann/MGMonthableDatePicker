//
//  DatePickerableView.swift
//  MGMonthableDatePicker
//
//  Created by Winann on 12/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import MGMonthableDatePicker

class DatePickerableView: UIView {

    var dateSelectView: MGMonthableDatePicker = {
        let pickerView = MGMonthableDatePicker()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        pickerView.beginDate = dateformatter.date(from: "2016-5-30")!
        pickerView.endDate = dateformatter.date(from: "2019-12-31")!
        return pickerView
    }()
    
    @IBAction func normalAction(_ sender: UIButton) {
        selectDate { (isCancel, isOnlyMonth, selectDate) in
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            print(dateformatter.string(from: selectDate!))
        }
    }
    @IBAction func dailyAction(_ sender: Any) {
        dateSelectView.style = .doubleDaily
        selectDate { (isCancel, isOnlyMonth, selectDate) in
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            print(dateformatter.string(from: selectDate!))
        }
    }
    @IBAction func singleMonthAction(_ sender: Any) {
        dateSelectView.style = .singleMonthly
        selectDate { (isCancel, isOnlyMonth, selectDate) in
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            print(dateformatter.string(from: selectDate!))
        }
    }
    @IBAction func singleDailyAction(_ sender: Any) {
        dateSelectView.style = .singleDaily
        selectDate { (isCancel, isOnlyMonth, selectDate) in
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            print(dateformatter.string(from: selectDate!))
        }
    }

}

extension DatePickerableView: MonthOrDayStyleDatePickable {
    
}
