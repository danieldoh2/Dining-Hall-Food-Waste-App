//
//  ClockInViewController.swift
//  Clock-In
//
//  Created by William Lee on 2022/7/12.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import FGRoute

extension UIDevice {

    func getIP() -> String? {
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                guard let interface = ptr?.pointee else {
                    return nil
                }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    guard let ifa_name = interface.ifa_name else {
                        return nil
                    }
                    let name: String = String(cString: ifa_name)
                    
                    if name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                    
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
}


class ClockInViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var locationInLabel: UILabel!
    @IBOutlet weak var statusControl: UISegmentedControl!
    
    
    var time: String = ""
    var location: String = ""
    var status: String = ""
    var IP: String = ""
    var project: String = ""
    
    let button = UIButton(type: .system)
    
    
    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginviewcontroller = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginviewcontroller
    }
        
    
    func onChange(sender: UISegmentedControl) -> String {
        // 印出選到哪個選項 從 0 開始算起
        print("status", sender.selectedSegmentIndex)

        // 印出這個選項的文字
        print(
            sender.titleForSegment(
                at: sender.selectedSegmentIndex))
        return (sender.titleForSegment(at: sender.selectedSegmentIndex) as String?)!
    }
    
    @IBAction func send(_ sender: Any) {
        if FGRoute.isWifiConnected() == true{
            IP = (FGRoute.getIPAddress() as String?)!
        }else{
            IP = (self.getIPAddress() as String?)!
        }
        location = (locationInLabel.text as String?)!
        time = (timeInLabel.text as String?)!
        status = onChange(sender: statusControl)
        project = (button.titleLabel?.text as String?)!
        print("IP",IP)
        
        let clockin = PFObject(className: "ClockIn")
        clockin["IP"] = IP
        clockin["location"] = location
        clockin["time"] = time
        clockin["status"] = status
        clockin["project"] = project
        clockin["owner"] = PFUser.current()!
        
        clockin.saveInBackground{(success, error) in
            if success{
                print("success")
                let alert = UIAlertController(title: "打卡成功", message: "您已打卡成功", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }else{
                print("error")
            }
        }
                                
    }
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()

        let date = Date()
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let hour = String(calendar.component(.hour, from: date))
        let minutes = String(calendar.component(.minute, from: date))
        
        timeInLabel.text = month + "/" + day + " " + hour + ":" + minutes
        
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        
        
        button.frame = CGRect(x: 120, y: 180, width: 200, height: 70)
        button.center.x = view.center.x
                view.addSubview(button)
                button.showsMenuAsPrimaryAction = true
                button.changesSelectionAsPrimaryAction = true
                button.menu = UIMenu(children: [
                    UIAction(title: "中科", handler: { action in
                        print("中科")
                    }),
                    UIAction(title: "德基", handler: { action in
                        print("德基")
                    }),
                    UIAction(title: "總公司", handler: { action in
                        print("總公司")
                    })
                ])
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationInLabel.text = String(locValue.latitude)
        locationInLabel.text! += ", "
        locationInLabel.text! += String(locValue.longitude)
        
    }
    
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
}
