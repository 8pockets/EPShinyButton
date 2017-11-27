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
        }
    }
    
    //MARK: - Shiny button
    @IBInspectable open var shine: Bool = true
    @IBInspectable open var shineColor: UIColor = UIColor(white: 1.0, alpha: 1)
    @IBInspectable open var shineSpeed: Double = 0.2
    
    //MARK: - Animations
    @IBInspectable open var animatedScaleWhenHighlighted: CGFloat = 1.0
    @IBInspectable open var animatedScaleDurationWhenHightlighted: Double = 0.2
    
    override open var isHighlighted: Bool {
        didSet {
            guard animatedScaleWhenHighlighted != 1.0 else {
                return
            }
            
            if isHighlighted{
                
                UIView.animate(withDuration: animatedScaleDurationWhenHightlighted, animations: {
//                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.8)
                    self.backgroundColor = UIColor(red: 0, green: 0.2, blue: 0.6, alpha: 0.4)
                })
                
                UIView.animate(withDuration: animatedScaleDurationWhenHightlighted, animations: {
                    self.transform = CGAffineTransform(scaleX: self.animatedScaleWhenHighlighted, y: self.animatedScaleWhenHighlighted)
                })
            }
            else{
                
                let l = CALayer()
                l.backgroundColor = shineColor.cgColor
                l.frame = CGRect(x: 0, y: 0, width: 1000.0, height: 50.0)
                l.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi * -45.0 / 180.0)))
                l.masksToBounds = true
                l.position = CGPoint(x: 0, y: 0)
                self.layer.insertSublayer(l, below: self.titleLabel?.layer)
                
                let x = CABasicAnimation(keyPath: "position.x")
                x.duration = shineSpeed
                x.toValue = self.frame.size.width
                x.isRemovedOnCompletion = false
                x.fillMode = kCAFillModeForwards
                
                let y = CABasicAnimation(keyPath: "position.y")
                y.duration = shineSpeed
                y.toValue = self.frame.size.height
                y.isRemovedOnCompletion = false
                y.fillMode = kCAFillModeForwards
                
                let fade = CAKeyframeAnimation(keyPath: "opacity")
                fade.duration = shineSpeed
                fade.values = [1.0, 0.7, 0.5, 0.3, 0.1]
                
                let ag = CAAnimationGroup()
                ag.duration = shineSpeed
                ag.delegate = self
                ag.animations = [x,y,fade]
                ag.setValue(l, forKey: "animationLayer")
                l.add(ag, forKey: "position")
                
                UIView.animate(withDuration: animatedScaleDurationWhenHightlighted, animations: {
                    self.backgroundColor = UIColor(red: 0, green: 0.2, blue: 0.6, alpha: 1.0)
                })
                
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
    
    //MARK: - Interface Builder Methods
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    //MARK: - Action Closure
    private var action: (() -> Void)?
    
    open func touchUpInside(action: (() -> Void)? = nil){
        self.action = action
    }
    
    @objc func tapped(sender: EPShinyButton) {
        self.action?()
    }
    
}

extension EPShinyButton: CAAnimationDelegate{
    
    //MARK: Material Button
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
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
