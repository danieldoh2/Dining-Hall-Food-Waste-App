//
//  TestViewController.swift
//  Clock-In
//
//  Created by William Lee on 2022/8/4.
//

import UIKit
import FSCalendar
import MapKit
import CoreLocation
import Parse
import FGRoute

class TestViewController: UIViewController, FSCalendarDelegate {
    
    @IBOutlet var calendar: FSCalendar!
    var returned: String = ""
    let button = UIButton(type: .system)
    var substit: String = ""
    var myDatePicker: UIDatePicker!
    var myLabel: UILabel!
    let fullScreenSize = UIScreen.main.bounds.size
    var from: String = ""
    var to: String = ""
    var secondDatePicker: UIDatePicker!
    @IBOutlet weak var firpicker: UIDatePicker!
    @IBOutlet weak var secpicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.appearance.titleDefaultColor = UIColor.label
        calendar.locale = NSLocale(localeIdentifier: "zh-CN") as Locale
        
        firpicker.locale = Locale(
            identifier: "zh_TW")
        
        button.frame = CGRect(x: view.center.x, y: view.center.y+50, width: 100, height: 40)
        button.center.x = view.center.x
                view.addSubview(button)
                button.showsMenuAsPrimaryAction = true
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
                button.changesSelectionAsPrimaryAction = true
                button.menu = UIMenu(children: [
                    UIAction(title: "代理人", handler: { action in
                        self.substit = ""
                    }),
                    UIAction(title: "1.李胤慶", handler: { action in
                        self.substit = "李胤慶"
                    }),
                    UIAction(title: "2.李澤宬", handler: { action in
                        self.substit = "李澤宬"
                    }),
                    UIAction(title: "3.李洧宬", handler: { action in
                        self.substit = "李洧宬"
                    }),
                    UIAction(title: "4.張妤菡", handler: { action in
                        self.substit = "張妤菡"
                    }),
                    UIAction(title: "5.李證菴", handler: { action in
                        self.substit = "李證菴"
                    })
                ])
        
        
        

        // 設置 NSDate 的格式
        let formatter = DateFormatter()

        // 設置時間顯示的格式
        formatter.dateFormat = "HH:mm"


        // 設置改變日期時間時會執行動作的方法
        firpicker.addTarget(self,
                               action:
                                #selector(TestViewController.firstdatePickerChanged),
                               for: .valueChanged)
        
        
        
        
        // 設置顯示的語言環境
        secpicker.locale = Locale(
            identifier: "zh_TW")

        // 設置改變日期時間時會執行動作的方法
        secpicker.addTarget(self,
                               action:
                                #selector(TestViewController.seconddatePickerChanged),
                               for: .valueChanged)
    }
    
    
    @objc func firstdatePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        
        from = formatter.string(
            from: datePicker.date)
    }
    
    @objc func seconddatePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        
        to = formatter.string(
            from: datePicker.date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let string = formatter.string(from: date)
        returned = string
        print("\(string)")
    }

    @IBAction func send(_ sender: Any) {
        print("returned", returned)
        print(substit)
        print("from", from)
        print("to", to)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY HH:mm"
        let currentTime = formatter.string(from: date)
        
        var Message: String = ""
        
        if String(currentTime.prefix(10))==returned{
            from = String(currentTime.suffix(5))
        }
        
        if from == "" {
            from = String(currentTime.suffix(5))
        }
        
        if returned == "" {
            if Message == ""{
                Message += "請選擇日期"
            }else{
                Message += "/請選擇日期"
            }
        }
        
        if substit == "" {
            if Message == ""{
                Message += "請選擇代理人"
            }else{
                Message += "/請選擇代理人"
            }
        }
        
        if to == "" {
            if Message == ""{
                Message += "請選擇到什麼時間"
            }else{
                Message += "/請選擇到什麼時間"
            }
        }
        
        var time: String = ""
        time = from + "-"
        time = time + to
        
        
        var value: Bool = true
        if Message != "" {
            value = false
        }
        
        print("value", value)
        
        
        
        if value == true{
            let leave = PFObject(className: "leave")
            leave["time"] = time
            leave["agent"] = self.substit
            leave["date"] = self.returned
            leave["owner"] = PFUser.current()!
            
            leave.saveInBackground{(success, error) in
                if value == true {
                    let alert = UIAlertController(title: "請假成功", message: "您已請假成功", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "錯誤", message: Message, preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "錯誤", message: Message, preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            
            let defaultColor = appearance.titleDefaultColor
            
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    return .orange
                } else {
                    return defaultColor
                }
            } else {
                return defaultColor
            }
            
        }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            self.calendar?.reloadData()
        }
    
    @IBAction func LOGOUT(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginviewcontroller = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginviewcontroller
    }
    
    
}
