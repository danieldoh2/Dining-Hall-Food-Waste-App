//
//  breakViewController.swift
//  Clock-In
//
//  Created by William Lee on 2022/8/3.
//

import UIKit
import FSCalendar
import Parse

class breakViewController: UIViewController, FSCalendarDelegate {
    
    
    @IBOutlet var calendar: FSCalendar!
    let button = UIButton(type: .system)
    var dateForBreak = ""
    
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginviewcontroller = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginviewcontroller
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string  = formatter.string(from: date)
        dateForBreak = string
        print("\(string)")
        return string
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.appearance.titleDefaultColor = UIColor.label
        calendar.locale = NSLocale(localeIdentifier: "zh-CN") as Locale
        
        button.frame = CGRect(x: view.center.x, y: view.center.y+50, width: 200, height: 100)
        button.center.x = view.center.x
                view.addSubview(button)
                button.showsMenuAsPrimaryAction = true
                button.changesSelectionAsPrimaryAction = true
                button.menu = UIMenu(children: [
                    UIAction(title: "代理人", handler: { action in
                        print("代理人")
                    }),
                    UIAction(title: "1.李胤慶", handler: { action in
                        print("1.李胤慶")
                    }),
                    UIAction(title: "2.李澤宬", handler: { action in
                        print("2.李澤宬")
                    }),
                    UIAction(title: "3.李洧宬", handler: { action in
                        print("3.李洧宬")
                    }),
                    UIAction(title: "4.張妤菡", handler: { action in
                        print("4.張妤菡")
                    }),
                    UIAction(title: "5.李證菴", handler: { action in
                        print("5.李證菴")
                    })
                ])
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let clockin = PFObject(className: "ClockIn")
        
        
        clockin.saveInBackground{(success, error) in
            if success{
                print("success")
                let alert = UIAlertController(title: "請假成功", message: "您已請假成功", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }else{
                print("error")
            }
        }
    }

    
    

}
