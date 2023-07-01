//
//  ViewController.swift
//  HW_CountDown_Date
//
//  Created by 曹家瑋 on 2023/6/27.
//



import UIKit

/// 加入 UITextFieldDelegate 協議
class ViewController: UIViewController, UITextFieldDelegate {

    /// 時間
    @IBOutlet weak var datePicker: UIDatePicker!
    /// 現在時間
    @IBOutlet weak var currentTimeLabel: UILabel!
    /// 選取的時間
    @IBOutlet weak var selectedTimeLabel: UILabel!
    /// 倒數計時顯示
    @IBOutlet weak var countDownLabel: UILabel!
    
    /// 添加任務事項時間的View
    @IBOutlet weak var eventAndDateView: UIView!
    /// 輸入任務事項
    @IBOutlet weak var eventTextField: UITextField!
    /// 顯示任務事項的 Label
    @IBOutlet weak var eventLabel: UILabel!
    
    
    /// 儲存使用者透過日期選擇器選擇的日期和時間。
    var selectedDate: Date?
    /// 倒數計時
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 設置 DatePicker 的模式（日期、時間）
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        
        /// 在 viewDidLoad 中設置定時器以每秒調用一次 updateLabels。
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
            self.updateLabels()
        })
        
        /// 使用 Date() 獲取當前時間
        let now = Date()
        /// 將當前時間 now 轉為字串
        let dateFormatter = createDateFormatter()
        currentTimeLabel.text = dateFormatter.string(from: now)
        
        /// 初始 countDownLabel、selectedTimeLabel
        selectedTimeLabel.text = "Please Click Plus Mark"
        countDownLabel.text = "No Time Selected"

        /// 讓使用者不能選擇已經過去的時間
        datePicker.minimumDate = Date()
        
        /// 隱藏eventAndDateView（透過addEventAndDateButtonTapped來顯示）
        eventAndDateView.isHidden = true
        
        /// eventTextField 的 delegate （與textFieldShouldReturn關聯）
        eventTextField.delegate = self
    
    }
    
    
    /// 點選Button 可以呼叫出添加任務、時間
    @IBAction func addEventAndDateButtonTapped(_ sender: UIButton) {
        eventAndDateView.isHidden = false
    }
    
    
    /// 每次輸入完任務事項並點擊確定按鈕後，任務事項就會顯示在 eventLabel 上，而清空的部分交給 TextField 的 clearButton。
    @IBAction func eventDoneButtonTapped(_ sender: UIButton) {
        
        /// 將eventTextField的內容賦值給eventLabel的文字
        eventLabel.text = eventTextField.text
        
        /// 當輸入完成之後點擊 eventDoneButtonTapped可以隱藏eventAndDateView
        eventAndDateView.isHidden = true

    }
    
    
    /// 時間日期選擇
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
         /// 將選擇的時間賦值給 selectedDate
        selectedDate = sender.date
//        print("Selected Date: \(selectedDate)")   /// 測試
        
        /// 字串化 selectedDate（給selectedTimeLabel使用）
        /// 使用 DateFormatter() 完成日期到字符串的轉換
        let dateFormatter = createDateFormatter()
        /// 強制解包 selectedDate。這是因為 selectedDate 是一個可選的值 (Optional)。
        if let selectedDate = selectedDate {
            selectedTimeLabel.text = dateFormatter.string(from: selectedDate)
        }
        
        /// 確保一旦使用者選擇新日期時，已經在進行的倒數計時器能被重置並重新計時。
        timer?.invalidate()             /// 停止當前的計時器
        timer = nil
        /// 開始一個新的定時器
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
            self.updateLabels()
        })
        
    }
    
    
    /// 重置按鈕（測試）
    @IBAction func restButtonTapped(_ sender: UIButton) {
        
        eventTextField.text = ""
        selectedTimeLabel.text = "Please Click Plus Mark"
        countDownLabel.text = "No Time Selected"
        
        /// 重置 datePicker 為當前時間（測試）
        datePicker.date = Date()
        
        /// 重置 selectedDate （不然countDownLabel會一直更新）
        selectedDate = nil
        
        /// 停止 current timer
        timer?.invalidate()
        timer = nil
        
        /// 重置 timer（測試）
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
            self.updateLabels()
        })
    }
    
    
    /// 每秒鐘調用一次的定時器（更新 currentTimeLabel 和 countDownLabel）
    func updateLabels() {
        
        let now = Date()        /// 使用 Date() 獲取當前時間
        
        /// 調用 createDateFormatter 將當前時間 now 轉為字串
        let dateFormatter = createDateFormatter()
        currentTimeLabel.text = dateFormatter.string(from: now)
        
        /// 更新 countDownLabel
        if let selectedDate = selectedDate {
            
            /// 如果選擇的日期在現在時間之前或等於現在時間，停止定時器並更新倒數時間標籤。（避免繼續倒數出現負數）
            if selectedDate <= now {
                timer?.invalidate()
                timer = nil
                countDownLabel.text = "Countdown Finished"
            } else {
                let calendar = Calendar.current
                /// 使用 Calendar 的 dateComponents(_:from:to:) 獲取當前時間 和 selectedDate 之間的差異，
                let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: selectedDate)
                countDownLabel.text = "\(components.day ?? 0) 天, \(components.hour ?? 0) 小時, \(components.minute ?? 0) 分鐘, \(components.second ?? 0) 秒."
            }
        }
        else {
            countDownLabel.text = "No Time Selected"
        }
        
    }
    
    
    /// 調用 createDateFormatter() 來將日期格式化
    func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy, HH:mm:ss"
    
        return dateFormatter
    }
    
    
    ///  添加 UITextFieldDelegate 藉此達到隱藏鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





//import UIKit
//
///// 加入 UITextFieldDelegate 協議
//class ViewController: UIViewController, UITextFieldDelegate {
//
//    /// 時間
//    @IBOutlet weak var datePicker: UIDatePicker!
//    /// 現在時間
//    @IBOutlet weak var currentTimeLabel: UILabel!
//    /// 選取的時間
//    @IBOutlet weak var selectedTimeLabel: UILabel!
//    /// 倒數計時顯示
//    @IBOutlet weak var countDownLabel: UILabel!
//
//    /// 添加任務事項時間的View
//    @IBOutlet weak var eventAndDateView: UIView!
//    /// 輸入任務事項
//    @IBOutlet weak var eventTextField: UITextField!
//    /// 顯示任務事項的 Label
//    @IBOutlet weak var eventLabel: UILabel!
//
//
//    /// 儲存使用者透過日期選擇器選擇的日期和時間。
//    var selectedDate: Date?
//    /// 倒數計時
//    var timer: Timer?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        /// 設置 DatePicker 的模式（日期、時間）
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.preferredDatePickerStyle = .inline
//
//        /// 在 viewDidLoad 中設置定時器以每秒調用一次 updateLabels。
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
//            self.updateLabels()
//        })
//
//        let now = Date()        /// 使用 Date() 獲取當前時間
//        /// 將當前時間 now 轉為字串
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .medium
//        dateFormatter.locale = Locale(identifier: "zh_TW")
//        dateFormatter.dateFormat = "EEEE, MMM d, yyyy, HH:mm:ss"
//        currentTimeLabel.text = dateFormatter.string(from: now)
//
//        /// 初始 countDownLabel、selectedTimeLabel
//        selectedTimeLabel.text = "Please Click Plus Mark"
//        countDownLabel.text = "No Time Selected"
//
//
//
//        /// 讓使用者不能選擇已經過去的時間
//        datePicker.minimumDate = Date()
//
//        /// 隱藏eventAndDateView
//        eventAndDateView.isHidden = true
//
//        /// eventTextField 的 delegate （與textFieldShouldReturn關聯）
//        eventTextField.delegate = self
//
//    }
//
//
//    /// 點選Button 可以呼叫出添加任務、時間
//    @IBAction func addEventAndDateButtonTapped(_ sender: UIButton) {
//        eventAndDateView.isHidden = false
//    }
//
//
//    /// 每次輸入完任務事項並點擊確定按鈕後，任務事項就會顯示在 eventLabel 上，而清空的部分交給 TextField 的 clearButton。
//    @IBAction func eventDoneButtonTapped(_ sender: UIButton) {
//
//        /// 將eventTextField的內容賦值給eventLabel的文字
//        eventLabel.text = eventTextField.text
//
//        /// 當輸入完成之後點擊 eventDoneButtonTapped可以隱藏eventAndDateView
//        eventAndDateView.isHidden = true
//
//    }
//
//
//    /// 時間日期選擇
//    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
//
//         /// 將選擇的時間賦值給 selectedDate
//        selectedDate = sender.date
////        print("Selected Date: \(selectedDate)")   /// 測試
//
//        /// 字串化 selectedDate（給selectedTimeLabel使用）
//        /// 使用 DateFormatter() 完成日期到字符串的轉換
//        let dateFormatter = createDateFormatter()
//        /// 強制解包 selectedDate。這是因為 selectedDate 是一個可選的值 (Optional)。
//        if let selectedDate = selectedDate {
//            selectedTimeLabel.text = dateFormatter.string(from: selectedDate)
//        }
//
//        /// 確保一旦使用者選擇新日期時，已經在進行的倒數計時器能被重置並重新計時。
//        timer?.invalidate()             /// 停止當前的計時器
//        timer = nil
//        /// 開始一個新的定時器
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
//            self.updateLabels()
//        })
//
//    }
//
//
//    /// 重置按鈕（測試）
//    @IBAction func restButtonTapped(_ sender: UIButton) {
//
//        eventTextField.text = ""
//        selectedTimeLabel.text = "Please Click Plus Mark"
//        countDownLabel.text = "No Time Selected"
//
//
//        /// 重置 selectedDate （不然countDownLabel會一直更新）
//        selectedDate = nil
//        /// 停止 current timer
//        timer?.invalidate()
//        timer = nil
//    }
//
//
//    /// 每秒鐘調用一次的定時器（更新 currentTimeLabel 和 countDownLabel）
//    func updateLabels() {
//
//        let now = Date()        /// 使用 Date() 獲取當前時間
//
//        /// 調用 createDateFormatter 將當前時間 now 轉為字串
//        let dateFormatter = createDateFormatter()
//        currentTimeLabel.text = dateFormatter.string(from: now)
//
//        /// 更新 countDownLabel
//        if let selectedDate = selectedDate {
//
//            /// 如果選擇的日期在現在時間之前或等於現在時間，停止定時器並更新倒數時間標籤。（避免繼續倒數出現負數）
//            if selectedDate <= now {
//                timer?.invalidate()
//                timer = nil
//                countDownLabel.text = "Countdown Finished"
//            } else {
//                let calendar = Calendar.current
//                /// 使用 Calendar 的 dateComponents(_:from:to:) 獲取當前時間 和 selectedDate 之間的差異，
//                let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: selectedDate)
//                countDownLabel.text = "\(components.day ?? 0) 天, \(components.hour ?? 0) 小時, \(components.minute ?? 0) 分鐘, \(components.second ?? 0) 秒."
//            }
//        }
//        else {
//            countDownLabel.text = "No Time Selected"
//        }
//
//    }
//
//
//    /// 調用 createDateFormatter() 來計利日期格式化器
//    func createDateFormatter() -> DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .medium
//        dateFormatter.locale = Locale(identifier: "zh_TW")
//        dateFormatter.dateFormat = "EEEE, MMM d, yyyy, HH:mm:ss"
//
//        return dateFormatter
//    }
//
//
//    ///  添加 UITextFieldDelegate 藉此達到隱藏鍵盤
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}





/// (初始版）
///
//import UIKit
//
//class ViewController: UIViewController {
//
//    /// 時間
//    @IBOutlet weak var datePicker: UIDatePicker!
//    /// 現在時間
//    @IBOutlet weak var currentTimeLabel: UILabel!
//    /// 選取的時間
//    @IBOutlet weak var selectedTimeLabel: UILabel!
//    /// 倒數計時顯示
//    @IBOutlet weak var countDownLabel: UILabel!
//
//
//    /// 儲存使用者透過日期選擇器選擇的日期和時間。
//    var selectedDate: Date?
//    /// 倒數計時
//    var timer: Timer?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        /// 設置 DatePicker 的模式（日期、時間）
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.preferredDatePickerStyle = .automatic
//
//        /// 在 viewDidLoad 中設置定時器以每秒調用一次 updateLabels。
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
//            self.updateLabels()
//        })
//
//    }
//
//    // 時間日期選擇
//    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
//
//         /// 將選擇的時間賦值給 selectedDate
//        selectedDate = sender.date
////        print("Selected Date: \(selectedDate)")   /// 測試
//
//        /// 字串化 selectedDate（給selectedTimeLabel使用）
//        /// 使用 DateFormatter() 完成日期到字符串的轉換
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
//        /// 強制解包 selectedDate。這是因為 selectedDate 是一個可選的值 (Optional)。
//        if let selectedDate = selectedDate {
//            selectedTimeLabel.text = dateFormatter.string(from: selectedDate)
//        }
//
//        /// 確保一旦使用者選擇新日期時，已經在進行的倒數計時器能被重置並重新計時。
//        timer?.invalidate()             /// 停止當前的計時器
//        timer = nil
//
//        /// 開始一個新的定時器
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { Timer in
//            self.updateLabels()
//        })
//
//    }
//
//
//    /// 每秒鐘調用一次的定時器（更新 currentTimeLabel 和 countDownLabel）
//    func updateLabels() {
//
//        let now = Date()        /// 使用 Date() 獲取當前時間
//        /// 將當前時間 now 轉為字串
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .medium
//        currentTimeLabel.text = dateFormatter.string(from: now)
//
//        /// 更新 countDownLabel
//        if let selectedDate = selectedDate {
//
//            let calendar = Calendar.current
//            /// 使用 Calendar 的 dateComponents(_:from:to:) 獲取當前時間 和 selectedDate 之間的差異，
//            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: selectedDate)
//            countDownLabel.text = "\(components.day ?? 0) days, \(components.hour ?? 0) hours, \(components.minute ?? 0) minutes, \(components.second ?? 0) seconds."
//        }
//        else {
//            countDownLabel.text = "沒有選擇時間"
//        }
//
//    }
//
//
//}

