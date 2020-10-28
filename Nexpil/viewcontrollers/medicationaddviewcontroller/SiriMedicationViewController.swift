//
//  SiriMedicationViewController.swift
//  Nexpil
//
//  Created by Admin on 5/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

import Speech

class SiriMedicationViewController: InformationCardEditViewController, SFSpeechRecognizerDelegate {
    
    

    @IBOutlet weak var labelmsg: UILabel!
    @IBOutlet weak var micbtn: GradientView!
    @IBOutlet weak var ctfHowTo: ShadowInput!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var isButtonEnabled = false
    
    //var visualEffectView:VisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        textView.viewShadow()
        
        let backImage = UIImage(named: "Back")
        let closeImage = UIImage(named:"Closebutton")?.withRenderingMode(.alwaysOriginal)
        let logoImage = UIImage(named: "Progress Bar3")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        /*
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        */
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
 
        
        self.hideKeyboardWhenTappedAround()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showImage))
//        helpbtn.layer.cornerRadius = 10.0
//        helpbtn.layer.masksToBounds = true
//        helpbtn.addGestureRecognizer(gesture)
        //textField.titleFormatter = {$0}
        
        ctfHowTo.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.startRecording1))
        /*
        micbtn.layer.cornerRadius = 10.0
        micbtn.layer.masksToBounds = true
        */
        micbtn.addGestureRecognizer(gesture1)
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            
            switch authStatus {
            case .authorized:
                self.isButtonEnabled = true
                
            case .denied:
                self.isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                self.isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                self.isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            /*
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
            */
        }
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
//        nextBtn.addGestureRecognizer(gesture2)
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
//        backBtn.addGestureRecognizer(gesture3)
        
        visualEffectView = self.view.backgroundBlur(view: self.view)
        
    }
    /*
    func removeShadow() {
        visualEffectView?.removeFromSuperview()
    }
    */
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if ctfHowTo.valueText.isEmpty == true {
            DataUtils.messageShow(view: self, message: "Please input Medication Instruction.", title: "")
            return
        }
        /*
        let num = textField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if num != ""
        {
            DataUtils.setMedicationDose(name: num)
        }
        else
        {
            DataUtils.setMedicationDose(name: "1")
        }
        let frequency = textField.text!.uppercased().components(separatedBy: "BY")
        if frequency.count == 2
        {
            DataUtils.setMedicationFrequency(name: frequency[1])
        }
        else {
            DataUtils.setMedicationFrequency(name: "")
        }
        */
        DataUtils.setMedicationFrequency(name: ctfHowTo.valueText)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1//3
        appDelegate.pageViewController?.gotoPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        let medicationname = DataUtils.getMedicationName()!
        labelmsg.text = "How do you take your " + medicationname + "?"
        if DataUtils.getMedicationFrequency()?.isEmpty == false
        {
            self.ctfHowTo.textView.text = DataUtils.getMedicationFrequency()
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

    @IBAction func closeWindow(_ sender: Any) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func showImage(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "board_3_howto_prescript.png"//"dosehelpimage.png"
        //viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func startRecording1(sender : UITapGestureRecognizer) {
        if isButtonEnabled == false
        {
            return
        }
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            
        } else {
            startRecording()           
            let alert = UIAlertController(title: "", message: "Listening your instructions", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction!) in
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        /*
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        */
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
                //self.textView.text = result?.bestTranscription.formattedString  //9
                self.ctfHowTo.valueText = (result?.bestTranscription.formattedString)!  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
        
    }
    @IBAction func gotoNext(_ sender: Any) {
        if self.ctfHowTo.textView.text!.isEmpty == true {
            DataUtils.messageShow(view: self, message: "Please input Medication Instruction.", title: "")
            return
        }
        DataUtils.setMedicationDose(name: self.ctfHowTo.textView.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1//3
        appDelegate.pageViewController?.gotoPage()
        
    }
    @IBAction func siriStart(_ sender: Any) {
        
    }
    
    @IBAction func gotoSummaryScreenViewController(_ sender: Any) {
        
        if self.ctfHowTo.textView.text!.isEmpty == true {
            DataUtils.messageShow(view: self, message: "Please input Medication Instruction.", title: "")
            return
        }
        DataUtils.setMedicationFrequency(name: self.ctfHowTo.textView.text!)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "SummaryScreenViewController") as! SummaryScreenViewController
        self.navigationController?.pushViewController(medicationController, animated: true)
    }
}
