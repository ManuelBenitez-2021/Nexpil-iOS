//
//  FAButton.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/3.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

public enum DTZFABAnimationType {
    case scale
    case none
}

open class FAButton: UIView {
    // MARK: - Properties
    
    // Button size
    open var size: CGFloat = 56 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Padding from buttom right of superview
    open var paddingX: CGFloat = 14 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open var paddingY: CGFloat = 14 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var animationSpeed: Double = 0.1
    
    @IBInspectable open var buttonColor: UIColor = UIColor(red: 239 / 255, green: 72 / 255, blue: 54 / 255, alpha: 1) {
        
        didSet {
            setNeedsDisplay();
        }
    }
    
    @IBInspectable open var buttonImage: UIImage? {
        
        didSet {
            setNeedsDisplay();
        }
    }
    
    open var plusColor: UIColor = UIColor.white
    
    open var animationType: DTZFABAnimationType = .scale
    
    // Set true if you use tableView etc
    open var isScrollView: Bool = true
    
    // Handler for touch up inside button
    open var handler: ((FAButton) -> Void)? = nil
    
    // Button shape layer
    fileprivate var circleLayer: CAShapeLayer = CAShapeLayer()
    
    // Plus icon shape layer
    fileprivate var plusLayer: CAShapeLayer = CAShapeLayer()
    
    // Button image view
    fileprivate var buttonImageView: UIImageView = UIImageView()
    
    // If you created button from storyboard, set true
    fileprivate var isCustomFrame: Bool = false
    
    // MARK: - Initialize
    
    // Init with default property
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        backgroundColor = UIColor.clear
        setObserver()
    }
    
    // Init with custom size
    public init(size: CGFloat) {
        self.size = size
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        backgroundColor = UIColor.clear
        setObserver()
    }
    
    // Init with custom frame
    public override init(frame: CGRect) {
        super.init(frame: frame)
        size = min(frame.size.width, frame.size.height)
        backgroundColor = UIColor.clear
        isCustomFrame = true
        setObserver()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isCustomFrame = true
        setObserver()
        
        self.addShadow(color: #colorLiteral(red: 0.2384634067, green: 0.2384634067, blue: 0.2384634067, alpha: 1), alpha: 0.3, x: 0, y: 2, blur: 3.0)
        
    }
    
    
    // MARK: - Method
    
    // Set size and frame
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        if isCustomFrame {
            size = min(frame.size.width, frame.size.height)
        } else {
            setRightButtomFrame()
        }
        
        setCircleLayer()
        
        guard buttonImage == nil else {
            setButtonImage()
            return
        }
        
        setPlusLayer()
    }
    
    // Button tapped
    open func tap() {
        switch animationType {
        case .scale:
            scaleAnimation()
        case .none:
            noneAnimation()
        }
    }
    
    fileprivate func setCircleLayer() {
        circleLayer.removeFromSuperlayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        circleLayer.backgroundColor = buttonColor.cgColor
        circleLayer.cornerRadius = size / 2
        layer.zPosition = 1
        layer.addSublayer(circleLayer)
    }
    
    fileprivate func setPlusLayer() {
        plusLayer.removeFromSuperlayer()
        plusLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        plusLayer.strokeColor = plusColor.cgColor
        plusLayer.lineWidth = 2.0
        plusLayer.path = plusBezierPath().cgPath
        layer.addSublayer(plusLayer)
    }
    
    fileprivate func setButtonImage() {
        buttonImageView.removeFromSuperview()
        buttonImageView = UIImageView(image: buttonImage)
        buttonImageView.tintColor = plusColor
        buttonImageView.frame = CGRect(x: size / 6, y: size / 6, width: size / 1.5, height: size / 1.5)
        buttonImageView.contentMode = .scaleAspectFit
        addSubview(buttonImageView)
    }
    
    fileprivate func setRightButtomFrame(_ keyboardSize: CGFloat = 0) {
        frame = CGRect(x: (superview!.frame.size.width - size) - paddingX,
                       y: (superview!.frame.size.height - size) - paddingY,
                       width: size,
                       height: size
        )
        //        frame.size.width += paddingX
        //        frame.size.height += paddingY
    }
    
    fileprivate func plusBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size / 2, y: size / 3))
        path.addLine(to: CGPoint(x: size / 2, y: size - size / 3))
        path.move(to: CGPoint(x: size / 3, y: size / 2))
        path.addLine(to: CGPoint(x: size - size / 3, y: size / 2))
        return path
    }
    
    fileprivate func setObserver() {
        //        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: "orientationDidChangeNotification", object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), "UIKeyboardWillShow", object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: "UIKeyboardWillHide", object: nil)
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deviceOrientationDidChange(_:)),
                                               name: NSNotification.Name(rawValue: "deviceOrientationDidChange"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name(rawValue: "UIKeyboardWillShow"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name(rawValue: "keyboardWillHide"),
                                               object: nil)
    }
    
    deinit {
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deviceOrientationDidChange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIKeyboardWillShow"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "keyboardWillHide"), object: nil)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tap()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handler?(self)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? UIView == superview && keyPath == "frame" {
            if isCustomFrame {
                size = min(frame.size.width, frame.size.height)
            } else {
                setRightButtomFrame()
            }
        } else if object as? UIScrollView == superview && keyPath == "contentOffset" {
            let scrollView = object as! UIScrollView
            frame.origin.x = ((self.superview!.bounds.size.width - size) - paddingX) + scrollView.contentOffset.x
            frame.origin.y = ((self.superview!.bounds.size.height - size) - paddingY) + scrollView.contentOffset.y
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        superview?.removeObserver(self, forKeyPath: "frame")
        if isScrollView {
            if let superviews = self.getAllSuperviews() {
                for superview in superviews {
                    if superview is UIScrollView {
                        superview.removeObserver(self, forKeyPath: "contentOffset", context: nil)
                    }
                }
            }
        }
        super.willMove(toSuperview: newSuperview)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superview?.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        if isScrollView {
            if let superviews = self.getAllSuperviews() {
                for superview in superviews {
                    if superview is UIScrollView {
                        superview.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                    }
                }
            }
        }
    }
    
    @objc internal func deviceOrientationDidChange(_ notification: Notification) {
//        guard let keyboardSize: CGFloat = (notification.userInfo?[UIResponder.UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height else {
//            return
//        }
//        if isCustomFrame {
//            size = min(frame.size.width, frame.size.height)
//        } else {
//            setRightButtomFrame(keyboardKey)
//        }
    }
    
    @objc internal func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardSize: CGFloat = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height else {
//            return
//        }
        
        if isScrollView {
            return
        }
        
//        if isCustomFrame {
//            size = min(frame.size.width, frame.size.height)
//        } else {
//            setRightButtomFrame(keyboardSize)
//        }
        
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
//            self.frame = CGRect(x: UIScreen.main.bounds.width - self.size - self.paddingX,
//                                y: UIScreen.main.bounds.height - self.size - keyboardSize - self.paddingY,
//                                width: self.size,
//                                height: self.size
//            )
//        }, completion: nil)
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
        if isScrollView {
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            if self.isCustomFrame {
                self.size = min(self.frame.size.width, self.frame.size.height)
            } else {
                self.setRightButtomFrame()
            }
        }, completion: nil)
    }
}

// Animation
extension FAButton {
    
    fileprivate func scaleAnimation() {
        UIView.animate(withDuration: animationSpeed, animations: {
            self.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
        }) { (bool) in
            UIView.animate(withDuration: self.animationSpeed, animations: {
                self.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        }
    }
    
    fileprivate func noneAnimation() {
        
    }
}

//
extension UIView {
    fileprivate func getAllSuperviews() -> [UIView]? {
        guard superview != nil else {
            return nil
        }
        
        var superviews: [UIView] = []
        superviews.append(superview!)
        if let allSuperviews = superview?.getAllSuperviews() {
            superviews.append(contentsOf: allSuperviews)
        }
        return superviews
    }
}

