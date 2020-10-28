@IBDesignable class NPButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var colorScheme: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 20)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .focused)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 20)
        self.setTitleColor(.white, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        shadowLayer.opacity = 0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        shadowLayer.opacity = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = bounds.height / 2
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
        }
        else {
            shadowLayer.removeFromSuperlayer()
        }
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.16
        shadowLayer.shadowRadius = 6
        
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
        }
        else {
            gradientLayer.removeFromSuperlayer()
        }
        
        gradientLayer.frame = bounds
        gradientLayer.colors = NPColorScheme(rawValue: colorScheme)!.gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(shadowLayer, at: 0)
        gradientLayer.cornerRadius = radius
        layer.insertSublayer(gradientLayer, above: shadowLayer)
    }
}
