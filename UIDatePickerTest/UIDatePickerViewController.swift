//
//  UIDatePickerViewController.swift
//  UIDatePickerTest
//
//  Created by 渡部学 on 2015/02/12.
//  Copyright (c) 2015年 watanabe. All rights reserved.
//

import Foundation
import UIKit

class UIDatePickerViewController: UITableViewController, UITextFieldDelegate {
    
    // DatePickerのインスタンス
    private var _datePicker: UIDatePicker!
    
    // 日付を設定するテキストフィールド
    private var _dataText: UITextField!
    
    //　DatePickerの表示状態
    private var _datePickerIsShowing = true
    
    //　DatePicker表示時のセルの高さ
    private let _DATEPICKER_CELL_HEIGHT: CGFloat = 210
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        // 使用するセルを登録する。
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        
        
        //　UITextFieldを生成する。
        self._dataText = UITextField()
        self._dataText.delegate = self //イベントを受け取る
        self._dataText.borderStyle = UITextBorderStyle.Line // 枠線
        
        //　UIDatePickerを生成する。
        self._datePicker = UIDatePicker()
        // イベント追加
        self._datePicker.addTarget(self, action: "onDatePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self._datePicker.datePickerMode = UIDatePickerMode.Date // 日付形式
        
        //　DatePickerを非表示にする。
        hideDatePickerCell()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を返す。
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //　セル生成する。
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "testCell")
        switch indexPath.row {
        case 0:
            // １行目のセルには、テキストフィールド
            cell.contentView.addSubview(self._dataText)
            self._dataText.frame = CGRectMake(cell.frame.width / 3, cell.frame.height / 3, cell.frame.width / 2, cell.frame.height / 2)

        case 1:
            // 2行目のセルには、DatePicker
            cell.contentView.addSubview(self._datePicker)
        default:
            println("想定外の行を指定されている。")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // セルの高さを返す。
        var height: CGFloat = self.tableView.rowHeight
        
        if (indexPath.row == 1){
            //　DatePicker行の場合は、DatePickerの表示状態に応じて高さを返す。
            // 表示の場合は、表示で指定している高さを、非表示の場合は０を返す。
            height =  self._datePickerIsShowing ? self._DATEPICKER_CELL_HEIGHT : CGFloat(0)
        }
        return height
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // セルを選択した場合に、日付入力テキストエリアがある行の場合は、DatePickerの表示切り替えを行う
        if (indexPath.row == 0) {
            dspDatePicker()
        }
    }
    
    
    func dspDatePicker() {
        // フラグを見て、切り替える
        if (self._datePickerIsShowing){
            hideDatePickerCell()
        } else {
            showDatePickerCell()
        }
    }
    
    func showDatePickerCell() {
         // フラグの更新
        self._datePickerIsShowing = true
        
        //　datePickerを表示する。
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        self._datePicker.hidden = false
        self._datePicker.alpha = 0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self._datePicker.alpha = 1.0
        }, completion: {(Bool) -> Void in
            
        })
    }
    
    func hideDatePickerCell() {
        // フラグの更新
        self._datePickerIsShowing = false
        
        //　datePickerを非表示する。
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.animateWithDuration(0.25,
        animations: {() -> Void in
            self._datePicker.alpha = 0
        }, completion: {(Bool) -> Void in
            self._datePicker.hidden = true
        })
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // テキストフィールドを編集する直前に呼び出されますので、この入力をキャセルし、代わりにDatePickerを表示します。
        dspDatePicker()
        return false
    }
    
    func onDatePickerValueChanged(sender: AnyObject) {
        // DatePickerの値変更時に呼ばれる。
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self._dataText.text =  dateFormatter.stringFromDate((sender as UIDatePicker).date)
    }

}

