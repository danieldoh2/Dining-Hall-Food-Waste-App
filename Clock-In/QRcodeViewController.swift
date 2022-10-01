//
//  QRcodeViewController.swift
//  Clock-In
//
//  Created by William Lee on 2022/10/1.
//

import UIKit
import Parse
import AVFoundation

class QRcodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var Output: UILabel!
    
    var imageOrientation: AVCaptureVideoOrientation?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var time: String = ""
    var returnedWeight: String = ""
    
    var eaten: String = ""
    
    let button = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    let button3 = UIButton(type: .system)
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button.frame = CGRect(x: UIScreen.main.bounds.size.width*0.5, y: 100, width: 200, height: 70)
        button.center.x = view.center.x
                view.addSubview(button)
                button.showsMenuAsPrimaryAction = true
                button.changesSelectionAsPrimaryAction = true
                button.menu = UIMenu(children: [
                    UIAction(title: "None", handler: { action in
                        print("None")
                    }),
                    UIAction(title: "Breakfast", handler: { action in
                        print("Breakfast")
                    }),
                    UIAction(title: "Lunch", handler: { action in
                        print("Lunch")
                    }),
                    UIAction(title: "Dinner", handler: { action in
                        print("Dinner")
                    })
                ])
        
        
        let date = Date()
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        if (minutes.count<2){
            minutes = "0"+minutes
        }
        time = month + "/" + day + " " + hour + ":" + minutes
        
        
        // Get an instance of the AVCaptureDevice class to initialize a
        // device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        // handler chiamato quando viene cambiato orientamento
        self.imageOrientation = AVCaptureVideoOrientation.portrait
                              
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
                   
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
                   
            // Set the input device on the capture session
            captureSession?.addInput(input)
                   
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                   
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            captureSession?.sessionPreset = .high
                   
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
                   
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                   
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)

            //start video capture
            captureSession?.startRunning()
                   
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.captureSession?.startRunning()
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        //self.captureSession?.stopRunning()
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    print(outputString)
                    self.Output.text = outputString
                    self.returnedWeight = outputString
                    
                }
            }
        }
        
    }
    
    
    
    
    @IBAction func SendInfo(_ sender: Any) {
        
        eaten = (button.titleLabel?.text as String?)!
        
        let Info = PFObject(className: "FoodInfo")
        
        let Food_Lst = returnedWeight.split(separator: " ")
        print("0",Food_Lst[0])
        print("1",Food_Lst[1])
        Info["Food_Type"] = Food_Lst[0]
        Info["Food_Weight"] = Food_Lst[1]
        Info["Time"] = time
        Info["owner"] = PFUser.current()!
        Info["Eaten_Before"] = eaten
        
        Info.saveInBackground{(success, error) in
            if success{
                print("success")
                let alert = UIAlertController(title: "Success", message: "", preferredStyle: UIAlertController.Style.alert)

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
