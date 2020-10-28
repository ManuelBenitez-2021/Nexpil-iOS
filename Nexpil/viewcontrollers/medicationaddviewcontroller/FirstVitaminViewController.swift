//
//  FirstVitaminViewController.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import BarcodeScanner
import AVFoundation

class FirstVitaminViewController: UIViewController,UITextViewDelegate,ShadowDelegate {
    
    

    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var addManually: UIImageView!
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    @IBOutlet weak var textView: UITextView!
    
    var visualEffectView:VisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.delegate = self
        textView.isUserInteractionEnabled = false
        // Get the back-facing camera for capturing videos
        var deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        if deviceDiscoverySession.devices.first == nil
        {
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        }
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        //view.layer.addSublayer(videoPreviewLayer!)
        
        view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.addManually1))
        addManually.isUserInteractionEnabled = true
        addManually.addGestureRecognizer(gesture2)
        
        visualEffectView = self.view.backgroundBlur(view: self.view)
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.showMessageBox))
        
        self.view.addGestureRecognizer(gesture3)
        
        
    }

    func removeShadow() {
        visualEffectView?.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Start video capture.
        captureSession.startRunning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        /*
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        */
        return viewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)
        
    }

    @objc func showMessageBox(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        /*
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.pageViewController?.closePageViewController()
         */
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManualSelectDialog") as! ManualSelectDialog
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func addManually1(sender : UITapGestureRecognizer) {
        if DataUtils.getPrescription() == 0
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.pageViewController?.pageControl.currentPage = 1
            appDelegate.pageViewController?.gotoPage()
        }
        else {
            //vitamin
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.vitaminPageViewController?.pageControl.currentPage = 1
            appDelegate.vitaminPageViewController?.gotoPage()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func gotoCancel(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addManually(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 1
        appDelegate.vitaminPageViewController?.gotoPage()
    }
}

extension FirstVitaminViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        //textView.text! = "\(code)"
        controller.dismiss(animated: true, completion: nil)
        
        let path = "https://api.fda.gov/drug/label.json?search=upc:\(code)"
        let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { [unowned self] (data, response, error) in
            
            
            
            guard error == nil else { return }
            guard data != nil else { return }
            print(data!)
            let decoder = JSONDecoder()
            let results = try! decoder.decode(Results.self, from: data!)
            
            if let result = results.results {
                print(result)
                DispatchQueue.main.async {
                    //self.textView.text = result[0].indications_and_usage?.joined(separator: "\n")
                    var what = result[0].description?[0] ?? ""
                    if what == ""
                    {
                        what = result[0].purpose?[0] ?? ""
                        
                        self.textView.text = what
                        
                    }
                }
            
            }
            else {
                DataUtils.messageShow(view: self, message: "Can not find Medication Info about code:\(code)", title: "")
            }
            
            /*
             let decoder = JSONDecoder()
             let results = try! decoder.decode(Results.self, from: data!)
             
             if let result = results.results {
             print(result)
             DispatchQueue.main.async {
             self.textView.text = result[0].indications_and_usage?.joined(separator: "\n")
             }
             }
             */
        }
        task.resume()
        
    }
}

/*
// MARK: - BarcodeScannerErrorDelegate
extension FirstVitaminViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension FirstVitaminViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
*/
extension FirstVitaminViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                //messageLabel.text = metadataObj.stringValue
                let code = metadataObj.stringValue!
                let path = "https://api.fda.gov/drug/label.json?search=upc:\(code)"
                let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                let session = URLSession.shared
                let task = session.dataTask(with: url!) { [unowned self] (data, response, error) in
                    
                    
                    
                    guard error == nil else { return }
                    guard data != nil else { return }
                    print(data!)
                    let decoder = JSONDecoder()
                    let results = try! decoder.decode(Results.self, from: data!)
                    
                    if let result = results.results {
                        print(result)
                        DispatchQueue.main.async {
                            //self.textView.text = result[0].indications_and_usage?.joined(separator: "\n")
                            var what = result[0].description?[0] ?? ""
                            if what == ""
                            {
                                what = result[0].purpose?[0] ?? ""
                                
                                self.textView.text = what
                                
                            }
                        }
                        
                    }
                    else {
                        DataUtils.messageShow(view: self, message: "Can not find Medication Info about code:\(code)", title: "")
                    }
                    
                }
                task.resume()
            }
        }
    }
    
}
