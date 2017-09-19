//
//  ViewController.swift
//  MGMonthableDatePicker
//
//  Created by winann on 09/11/2017.
//  Copyright (c) 2017 winann. All rights reserved.
//

import UIKit
import MGMonthableDatePicker

class ViewController: UIViewController {

    var dateSelectView: MGMonthableDatePicker = {
        let pickerView = MGMonthableDatePicker()
        pickerView.style = .singleMonthly
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-M"
        dateSelectView.beginDate = dateformatter.date(from: "2016-10")!
        dateSelectView.endDate = dateformatter.date(from: "2017-9")!
//        dateSelectView.currentDate = dateformatter.date(from: "2016-11")!
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

extension ViewController: MonthOrDayStyleDatePickable {
    
}

