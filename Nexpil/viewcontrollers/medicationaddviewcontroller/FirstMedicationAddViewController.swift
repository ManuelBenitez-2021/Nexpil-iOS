//
//  CameraViewController.swift
//  Vision
//
//  Created by Cagri Sahan on 6/14/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import UIKit
import AVKit



class FirstMedicationAddViewController: UIViewController,ShadowDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addManuallyButton: UIButton!
    
    var lastSampleTaken = Date()
    var timer: Timer!
    let session = AVCaptureSession()
    
    let dataOutput = AVCaptureVideoDataOutput()
    
    var visualEffectView:VisualEffectView?
    
    var prescription: NPPrescription?
    
    let finder = NPPrescriptionFinder.shared
    
    // Can add logo detection if need arises.
    let features: [Feature] = {
        let feature1: Feature = {
            let type = Type.DOCUMENT_TEXT_DETECTION
            return Feature(type: type)
        }()
        return [feature1]
    }()
    
    
    func removeShadow() {
        visualEffectView?.removeFromSuperview()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "InformationCardMedicationSelectViewController") as! InformationCardMedicationSelectViewController
        self.navigationController?.pushViewController(medicationController, animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addManually(_ sender: Any) {
        
//        self.view.addSubview(visualEffectView!)
        
        DataUtils.setMedicationName(name: "")
        DataUtils.setMedicationStrength(name: "")
        DataUtils.setMedicationFrequency(name: "")
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let medicationController = storyBoard.instantiateViewController(withIdentifier: "AddMedicationDialogViewController") as! AddMedicationDialogViewController
//        medicationController.delegate = self
//        medicationController.modalPresentationStyle = .overCurrentContext
//        self.present(medicationController, animated: false, completion: nil)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "InformationCardMedicationSelectViewController") as! InformationCardMedicationSelectViewController
        self.navigationController?.pushViewController(medicationController, animated: true)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
//        addManuallyButton.setGradient(colors: [#colorLiteral(red: 0.4862745098, green: 0.8862745098, blue: 0.9254901961, alpha: 1).cgColor, #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1).cgColor], angle: 97.0)
//        addManuallyButton.roundCorners([.topRight, .topLeft], radius: 10.0)
//        addManuallyButton.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: -3.0, blur: 6.0)
        //addManuallyButton.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1)
        
        closeButton.setGradient(colors: [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor], angle: 134.0)
        closeButton.roundCorners(.allCorners, radius: closeButton.frame.width/2)
        closeButton.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 5.0, blur: 15.0)
        
        guard let inputDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No camera found.")
        }
        guard let input = try? AVCaptureDeviceInput(device: inputDevice) else {
            fatalError("Can't get camera input.")
        }
        
        session.addInput(input)
        session.startRunning()
        
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = self.view.bounds
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        view.layer.insertSublayer(preview, at: 0)
        
        session.addOutput(dataOutput)
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        let sampleBufferQueue = DispatchQueue(label: "sampleBufferQueue")
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        visualEffectView = self.view.backgroundBlur(view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataUtils.getCameraStatus() == true
        {
            self.dismiss(animated: false, completion: nil)
            DataUtils.setCameraStatus(name: false)
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (timer) in
            self.session.stopRunning()
            if self.finder.drug != nil {
                self.prescription = self.finder.getPrescription()
                self.performSegue(withIdentifier: "summarySegue", sender: self)
            }
            else {
                print("notComplete")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "summarySegue" {
            timer.invalidate()
            URLSession.shared.finishTasksAndInvalidate()
            let vc = segue.destination as! SummaryScreenViewController
            vc.prescription = prescription!
        }
    }
}

extension FirstMedicationAddViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if lastSampleTaken.timeIntervalSinceNow < -0.75 {
            
            let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
            let uiimage = UIImage(cgImage: cgImage)
            let data = UIImageJPEGRepresentation(uiimage, 0.10)!
            
            
            lastSampleTaken = Date()
            let image = Image(fromContent: data.base64EncodedString())
            
            let requests = AnnotateImageRequest(image: image, features: features, context: nil)
            let request = Request(requests: [requests])
            request.perform { response in
                guard let texts = response.responses.first!.fullTextAnnotation else { return }
                let page = texts.pages[0]
                for i in 0..<page.blocks.count {
                    print("Block: \(i)")
                    for j in 0..<page.blocks[i].paragraphs.count {
                        print("Paragraph: \(j)")
                        print(page.blocks[i].paragraphs[j].text)
                    }
                }
                self.finder.delegate = self
                self.finder.userName = "Patient Test"
                self.finder.addResponse(response)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
}

extension FirstMedicationAddViewController: NPPrescriptionEventHandler {
    func handleEvent(_ event: NPPrescriptionEvent) {
        print(event)
        DispatchQueue.main.async { [unowned self] in
            switch event {
                //                    case .foundPrescriptionNumber:
                //                        self.prescriptionNumberPanel.text = self.prescriptionNumberPanel.text?.replacingOccurrences(of: "🚫", with: "✅")
                //                    case .foundDrugQuantity:
                //                        self.drugQuantityPanel.text = self.drugQuantityPanel.text?.replacingOccurrences(of: "🚫", with: "✅")
                //                    case .foundFillDate:
                //                        self.fillDatePanel.text = self.fillDatePanel.text?.replacingOccurrences(of: "🚫", with: "✅")
                //                    case .foundPharmacy:
                //                        self.pharmacyPanel.text = self.pharmacyPanel.text?.replacingOccurrences(of: "🚫", with: "✅")
                //                    case .foundDrug:
                //                        self.drugPanel.text = self.drugPanel.text?.replacingOccurrences(of: "🚫", with: "✅")
                //                    case .foundDirections:
                //                        self.directionsPanel.text = self.directionsPanel.text?.replacingOccurrences(of: "🚫", with: "✅")
                //                    case .foundDoctorName:
            //                        self.doctorNamePanel.text = self.doctorNamePanel.text?.replacingOccurrences(of: "🚫", with: "✅")
            case .prescriptionComplete:
                self.prescription = self.finder.getPrescription()
                self.performSegue(withIdentifier: "summarySegue", sender: self)
            default:
                break
            }
        }
    }
}
