//
//  EPShinyButton.swift
//  EPShinyButton
//
//  Created by 8pockets on 2017/11/27.
//  Copyright © 2017年 8pockets. All rights reserved.
//
import UIKit

@IBDesignable
open class EPShinyButton: UIButton {
    
    //MARK: - General Appearance
    @IBInspectable open var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable open var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            if let gradientLayer = gradient {
                gradientLayer.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable open var shadowColor: UIColor = UIColor.clear{
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable open var shadowOpacity: Float = 0{
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero{
        didSet{
            self.layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var shadowRadius: CGFloat = 0{
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable open var gradientEnabled: Bool = false{
        didSet{
            setupGradient()
        }
    }
    
    //MARK: - Gradient Background
    @IBInspectable open var gradientStartColor: UIColor = UIColor.clear{
        didSet{
            setupGradient()
        }
    }
    @IBInspectable open var gradientEndColor: UIColor = UIColor.clear{
        didSet{
            setupGradient()
        }
    }
    @IBInspectable open var gradientHorizontal: Bool = false{
        didSet{
            setupGradient()
        }
    }
    var gradient: CAGradientLayer?
    
    func setupGradient(){
        guard gradientEnabled != false else{
            return
        }
        
        gradient?.removeFromSuperlayer()
        gradient = CAGradientLayer()
        guard let gradient = gradient else { return }
        
        gradient.frame = self.layer.bounds
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = gradientHorizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 1)
        
        gradient.cornerRadius = self.cornerRadius
        
        self.layer.insertSublayer(gradient, below: self.imageView?.layer)
    }
    
    //MARK: - Animations
    @IBInspectable open var animatedScaleWhenHighlighted: CGFloat = 1.0
    @IBInspectable open var animatedScaleDurationWhenHightlighted: Double = 0.2
    
    override open var isHighlighted: Bool {
        didSet {
            guard animatedScaleWhenHighlighted != 1.0 else {
                return
            }
            
            if isHighlighted{
                                
                UIView.animate(withDuration: rippleSpeed, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.backgroundColor?.withAlphaComponent(0.4)
                }, completion: nil)
                
                UIView.animate(withDuration: animatedScaleDurationWhenHightlighted, animations: {
                    self.transform = CGAffineTransform(scaleX: self.animatedScaleWhenHighlighted, y: self.animatedScaleWhenHighlighted)
                })
            }
            else{
                
                let l = CALayer()
                l.backgroundColor = rippleColor.cgColor
                l.frame = CGRect(x: 0, y: 0, width: 1000.0, height: 50.0)
                l.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi * -45.0 / 180.0)))
                l.masksToBounds = true
                l.position = CGPoint(x: 0, y: 0)
                self.layer.insertSublayer(l, below: self.titleLabel?.layer)
                
                let x = CABasicAnimation(keyPath: "position.x")
                x.duration = rippleSpeed
                x.toValue = self.frame.size.width
                x.isRemovedOnCompletion = false
                x.fillMode = kCAFillModeForwards
                
                let y = CABasicAnimation(keyPath: "position.y")
                y.duration = rippleSpeed
                y.toValue = self.frame.size.height
                y.isRemovedOnCompletion = false
                y.fillMode = kCAFillModeForwards
                
                let fade = CAKeyframeAnimation(keyPath: "opacity")
                fade.duration = rippleSpeed
                fade.values = [1.0, 0.7, 0.5, 0.3, 0.1]
                
                let ag = CAAnimationGroup()
                ag.duration = rippleSpeed
                ag.delegate = self
                ag.animations = [x,y,fade]
                ag.setValue(l, forKey: "animationLayer")
                l.add(ag, forKey: "position")
                
                UIView.animate(withDuration: animatedScaleDurationWhenHightlighted, animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    @IBInspectable open var animatedScaleWhenSelected: CGFloat = 1.0
    @IBInspectable open var animatedScaleDurationWhenSelected: Double = 0.2
    
    override open var isSelected: Bool{
        didSet {
            guard animatedScaleWhenSelected != 1.0 else {
                return
            }
            
            UIView.animate(withDuration: animatedScaleDurationWhenSelected, animations: {
                self.transform = CGAffineTransform(scaleX: self.animatedScaleWhenSelected, y: self.animatedScaleWhenSelected)
            }) { (finished) in
                UIView.animate(withDuration: self.animatedScaleDurationWhenSelected, animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    //MARK: - Ripple button
    @IBInspectable open var ripple: Bool = false{
        didSet{
            self.clipsToBounds = true
        }
    }
    //    @IBInspectable open var rippleColor: UIColor = UIColor(white: 1.0, alpha: 1)
    @IBInspectable open var rippleColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    @IBInspectable open var rippleSpeed: Double = 1.0
    
    //MARK: - Checkbox
    @IBInspectable open var checkboxButton: Bool = false{
        didSet{
            if checkboxButton == true{
                self.setImage(uncheckedImage, for: .normal)
                self.setImage(checkedImage, for: .selected)
                self.addTarget(self, action: #selector(buttonChecked), for: .touchUpInside)
            }
        }
    }
    @IBInspectable open var checkedImage: UIImage?
    @IBInspectable open var uncheckedImage: UIImage?
    
    @objc func buttonChecked(sender:AnyObject){
        self.isSelected = !self.isSelected
    }
    
    //MARK: - Image
    ///Image UIButton content mode
    @IBInspectable open var imageViewContentMode: Int = UIViewContentMode.scaleToFill.rawValue{
        didSet{
            imageView?.contentMode = UIViewContentMode(rawValue: imageViewContentMode) ?? .scaleToFill
        }
    }
    @IBInspectable open var imageAlpha: CGFloat = 1.0 {
        didSet {
            if let imageView = imageView {
                imageView.alpha = imageAlpha
            }
        }
    }
    
    //MARK: - Action Closure
    private var action: (() -> Void)?
    
    open func touchUpInside(action: (() -> Void)? = nil){
        self.action = action
    }
    
    @objc func tapped(sender: EPShinyButton) {
        self.action?()
    }
    
    //MARK: - Loading
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    /**
     Show a loader inside the button, and enable or disable user interection while loading
     */
    open func showLoader(userInteraction: Bool = true){
        guard self.subviews.contains(indicator) == false else {
            return
        }
        self.isUserInteractionEnabled = userInteraction
        indicator.isUserInteractionEnabled = false
        indicator.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        UIView.transition(with: self, duration: 0.5, options: .curveEaseOut, animations: {
            self.titleLabel?.alpha = 0.0
            self.imageAlpha = 0.0
        }) { (finished) in
            self.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }
    
    open func hideLoader(){
        guard self.subviews.contains(indicator) == true else {
            return
        }
        
        self.isUserInteractionEnabled = true
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
        UIView.transition(with: self, duration: 0.5, options: .curveEaseIn, animations: {
            self.titleLabel?.alpha = 1.0
            self.imageAlpha = 1.0
        }) { (finished) in
        }
    }
    
    //MARK: - Interface Builder Methods
    override open func layoutSubviews() {
        super.layoutSubviews()
        gradient?.frame = self.layer.bounds
        self.imageView?.alpha = imageAlpha
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override open func prepareForInterfaceBuilder() {
    }
    
}

extension EPShinyButton: CAAnimationDelegate{
    
    //MARK: Material touch animation for ripple button
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        guard ripple == true else {
            return true
        }
        
        return true
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let layer: CALayer? = anim.value(forKeyPath: "animationLayer") as? CALayer
        if layer != nil{
            layer?.removeAnimation(forKey: "position")
            layer?.removeFromSuperlayer()
        }
    }
}


