//
//  MGMonthableDatePicker.swift
//  MogoPartner
//
//  Created by Winann on 09/08/2017.
//  Copyright © 2017 mogoroom. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height


/// 日期选择类型
///
/// - doubleMonthly: 可选，默认按月选择
/// - doubleDaily: 可选，默认按日选择
/// - singleMonthly: 只能选择月
/// - singleDaily: 只能选择日
public enum DateSelectStyle {
    case doubleMonthly
    case doubleDaily
    case singleMonthly
    case singleDaily
}


/// 日期选择控件
public class MGMonthableDatePicker: UIView {
    // MARK: - config
    
    /// 开始日期
    public var beginDate: Date = Date() {
        didSet {
            configBeginDate()
        }
    }
    
    /// 结束日期
    public var endDate: Date = Date() {
        didSet {
            configEndDate()
        }
    }
    
    /// 当前日期
    public var currentDate: Date = Date() {
        didSet {
            configCurrentDate()
        }
    }
    
    /// 日期选择样式
    public var style: DateSelectStyle = .doubleMonthly {
        didSet {
            switch style {
            case .doubleMonthly:
                changeMode(selectBtn: self.monthlyBtn)
                selectTypeHeight.constant = 32
                datePickerTop.constant = 55
            case .doubleDaily:
                changeMode(selectBtn: self.daylyBtn)
                selectTypeHeight.constant = 32
                datePickerTop.constant = 55
            case .singleMonthly:
                changeMode(selectBtn: self.monthlyBtn)
                selectTypeHeight.constant = 0
                datePickerTop.constant = 0
            case .singleDaily:
                changeMode(selectBtn: self.daylyBtn)
                selectTypeHeight.constant = 0
                datePickerTop.constant = 0
            }
        }
    }
    
    
    /// 选中的按钮边框颜色
    public var selectBorderColor: UIColor = UIColor(red: 46 / 255.0, green: 138 / 255.0, blue: 241 / 255.0, alpha: 1.0)
    /// 未选中的按钮边框颜色
    public var deselectBorderColor: UIColor = UIColor(red: 144 / 255.0, green: 144 / 255.0, blue: 144 / 255.0, alpha: 1.0)
    
    /// 日期选择的回调(参数：是否取消，是否只有月，时间字符串:yyyy-MM(-dd))
    var selectResult: ((Bool, Bool?, Date?) -> Void)?
    
    
    private var dateFormat = "yyyy-MM-dd" {
        didSet {
            dateFormatter.dateFormat = dateFormat
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormat
        return formatter
    }()
    
    fileprivate var yearBegin: Int = 0
    fileprivate var yearEnd: Int = 0
    fileprivate var firstYearBeginMonth: Int = 0
    fileprivate var lastYearEndMonth: Int = 0
    
    @IBOutlet var contentBGView: UIView!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var daylyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var selectTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var datePickerTop: NSLayoutConstraint!
    
    @IBOutlet weak var contentBGWhiteView: UIView!
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64))
        loadSubViews()
        configCurrentDate()
//        configCurrentDateStr()
    }
    
    // MARK: - 配置
    private func configBeginDate() {
        let interval = beginDate.timeIntervalSince(endDate)
        if interval > 0 {
            endDate = beginDate
            currentDate = beginDate
        }
        configCurrentDate()
    }
    private func configEndDate() {
        let interval = endDate.timeIntervalSince(beginDate)
        if interval < 0 {
            beginDate = endDate
            currentDate = endDate
        }
        configCurrentDate()
    }
    
    public func configCurrentDate() {
        if currentDate.timeIntervalSince(beginDate) < 0 {
            currentDate = beginDate
        } else if currentDate.timeIntervalSince(endDate) > 0 {
            currentDate = endDate
        }
        datePicker.minimumDate = beginDate
        datePicker.maximumDate = endDate
        datePicker.date = currentDate
        
        (yearBegin, firstYearBeginMonth) = yearMonthNum(date: beginDate)
        (yearEnd, lastYearEndMonth) = yearMonthNum(date: endDate)
        monthPicker.reloadComponent(0)
        let (currentYear, currentMonth) = yearMonthNum(date: currentDate)
        monthPicker.selectRow(currentYear - yearBegin, inComponent: 0, animated: false)
        monthPicker.reloadComponent(1)
        if monthPicker.selectedRow(inComponent: 0) == 0 {
            if firstYearBeginMonth > 0 {
                
                monthPicker.selectRow(currentMonth - firstYearBeginMonth, inComponent: 1, animated: false)
            }
        } else {
            monthPicker.selectRow(currentMonth - 1, inComponent: 1, animated: false)
        }
    }
    
    private func yearMonthNum(date: Date) -> (Int, Int) {
        let dateStr = dateFormatter.string(from: date)
        let dateStrs = dateStr.components(separatedBy: "-")
        guard dateStrs.count > 1 else {
            return (0, 0)
        }
        guard let year = Int(dateStrs[0]), let month = Int(dateStrs[1]) else {
            return (0, 0)
        }
        return (year, month)
    }
    
    private func changeDate(_ date: Date? = nil) {
        var tempDate = currentDate
        if let `date` = date {
            tempDate = date
        }
        
        if !self.daylyBtn.isSelected {
            dateFormat = "yyyy-MM"
            let today = Date()
            if dateFormatter.string(from: tempDate) == dateFormatter.string(from: today) {
                datePicker.date = today
            } else {
                datePicker.date = tempDate
            }
        } else {
            let (tempYear, tempMonth) = yearMonthNum(date: tempDate)
            monthPicker.selectRow(tempYear - yearBegin, inComponent: 0, animated: false)
            if monthPicker.selectedRow(inComponent: 0) == 0 {
                if firstYearBeginMonth > 0 {
                    
                    monthPicker.selectRow(tempMonth - firstYearBeginMonth, inComponent: 1, animated: false)
                }
            } else {
                monthPicker.selectRow(tempMonth - 1, inComponent: 1, animated: false)
            }
        }
    }
    
    
    func hidden() {
        layoutIfNeeded()
        contentViewBottom.constant = -300
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let `self` = self else { return }
            self.layoutIfNeeded()
        }) { [weak self] (finished) in
            guard let `self` = self else { return }
            self.isHidden = true
        }
        
    }
    
    func show() {
        layoutIfNeeded()
        self.isHidden = false
        contentViewBottom.constant = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let `self` = self else { return }
            self.layoutIfNeeded()
        }) { (finished) in
            
        }
        
    }
    
    
    private func loadSubViews() {
        Bundle(for: MGMonthableDatePicker.self).loadNibNamed("MGMonthableDatePicker", owner: self, options: nil)
        contentBGView.frame = bounds
        addSubview(contentBGView)
    }
    
    private func changeMode(selectBtn: UIButton) {
        guard !selectBtn.isSelected else { return }

        changeDate(selectDate())
        let selectBtn = selectBtn
        let isMonthly = selectBtn == monthlyBtn
        let deselectBtn = isMonthly ? daylyBtn : monthlyBtn
        selectBtn.isSelected = true
        selectBtn.layer.borderColor = selectBorderColor.cgColor
        deselectBtn?.isSelected = false
        deselectBtn?.layer.borderColor = deselectBorderColor.cgColor
        monthPicker.isHidden = !isMonthly
    }
    
    
    @objc private func cancelAction() {
        changeDate()
        hidden()
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelAction()
    }
    private func selectDate() -> Date? {
        let isMonthDate = self.monthlyBtn.isSelected
        if isMonthDate {
            if let year = pickerView(monthPicker, titleForRow: monthPicker.selectedRow(inComponent: 0), forComponent: 0),
                let month = pickerView(monthPicker, titleForRow: monthPicker.selectedRow(inComponent: 1), forComponent: 1){
                
                let yearStr = year.substring(to: year.characters.count - 1)
                let monthStr = month.substring(to: month.characters.count - 1)
                dateFormat = "yyyy-MM"
                let date = dateFormatter.date(from: "\(yearStr)-\(monthStr)")
                return date
            }
        } else {
            let date = datePicker.date
            return date
        }
        return nil
    }

    
    @IBAction func cancelAction(sender: UIButton) {
        cancelAction()
    }
    @IBAction func confirmAction(sender: UIButton) {
        self.hidden()
        guard let callBack = self.selectResult else { return }
        let isMonthDate = self.monthlyBtn.isSelected
        let selectDate = self.selectDate()
        if let date = selectDate {
            self.currentDate = date
        }
        callBack(false, isMonthDate, selectDate)
    }
    @IBAction func monthlyAction(sender: UIButton) {
        changeMode(selectBtn: self.monthlyBtn)
    }
    @IBAction func dailyAction(sender: UIButton) {
        changeMode(selectBtn: self.daylyBtn)
    }
    
}

extension MGMonthableDatePicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if 0 == component {
            return "\(yearBegin + row)" + "年"
        } else if pickerView.selectedRow(inComponent: 0) == 0 {
            return "\(firstYearBeginMonth + row)" + "月"
        } 
        return "\(1 + row)" + "月"
    }
}

extension MGMonthableDatePicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if 0 == component {
            return yearEnd - yearBegin + 1
        } else if 1 == component {
            if pickerView.selectedRow(inComponent: 0) == 0 {
                if firstYearBeginMonth > 0 {
                    
                    return 12 - firstYearBeginMonth + 1
                }
            } else if pickerView.selectedRow(inComponent: 0) == yearEnd - yearBegin {
                return lastYearEndMonth
            }
        }
        return 12
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if 0 == component {
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
}
