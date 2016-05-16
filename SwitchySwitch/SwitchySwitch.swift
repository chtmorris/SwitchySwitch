//
//  SwitchySwitch.swift
//  SwitchySwitch
//
//  Created by Charlie Morris on 16/05/2016.
//  Copyright © 2016 Mind Fund Studio. All rights reserved.
//

import UIKit

@IBDesignable final class SwitchySwitch: UIView {
    
    
    // ==================
    // MARK: - PROPERTIES
    // ==================
    
    @IBInspectable var barLength: CGFloat = 60 {
        didSet {
            
        }
    }
    
    @IBInspectable var barThickness:CGFloat = 20 {
        didSet {
            barLayer.cornerRadius = barThickness / 2
        }
    }
    
    @IBInspectable var barColor:UIColor = UIColor.blueColor() {
        didSet {
            barLayer.backgroundColor = barColor.CGColor
        }
    }
    
    @IBInspectable var knobShadowOpacity:Float = 0.3 {
        didSet {
            knobView.layer.shadowOpacity = knobShadowOpacity
        }
    }
    
    @IBInspectable var knobRadius:CGFloat = 20 {
        didSet {
            setKnobSizeFor(radius: knobRadius)
            knobView.layer.cornerRadius = knobRadius
            knobImage.frame = CGRect(x: knobRadius / 3, y: knobRadius / 3, width: knobRadius * 1.3, height: knobRadius * 1.3)
        }
    }
    
    @IBInspectable var knobShadowRadius:CGFloat = 1 {
        didSet {
            knobView.layer.shadowRadius = knobShadowRadius
        }
    }
    
    @IBInspectable var knobShadowColor:UIColor = UIColor.blackColor() {
        didSet {
            knobView.layer.shadowColor = knobShadowColor.CGColor
        }
    }
    
    @IBInspectable var knobColor:UIColor = UIColor.redColor() {
        didSet {
            knobView.backgroundColor = knobColor
        }
    }
    
    @IBInspectable let padding:CGFloat = 10
    
    @IBInspectable var on:Bool = false
    
    var offX:CGFloat {
        return padding
    }
    
    var onX:CGFloat {
        return barLength - padding
    }
    
    private var _isInitialLayout = true
    
    var pan:UIPanGestureRecognizer!
    var tap:UITapGestureRecognizer!
    
    // ================
    // MARK: - SUBVIEWS
    // ================
    
    let knobView = UIView()
    let barLayer = CALayer()
    let knobImage = UIImageView()
    
    
    // ============
    // MARK: - INIT
    // ============
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        // Setup Pan Gesture
        pan = UIPanGestureRecognizer(target: self, action: "panned:")
        addGestureRecognizer(pan)
        
        // Setup Tap Gesture
        tap = UITapGestureRecognizer(target: self, action: "tapped:")
        addGestureRecognizer(tap)
        
        // Setup bar
        barLayer.backgroundColor = UIColor.greenColor().CGColor
        barLayer.cornerRadius = barThickness / 2
        layer.addSublayer(barLayer)
        
        // Setup knob
        knobView.layer.cornerRadius = knobRadius
        knobView.translatesAutoresizingMaskIntoConstraints = true
        knobView.backgroundColor = UIColor.blueColor()
        knobView.layer.shadowRadius = knobShadowRadius
        knobView.layer.shadowOpacity = knobShadowOpacity
        knobView.layer.shadowColor = knobShadowColor.CGColor
        knobView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        setKnobSizeFor(radius: knobRadius)
        self.addSubview(knobView)
        
        // Setup image
        knobImage.image = UIImage(named: "WalkingMan")
        knobImage.frame = CGRect(x: knobRadius / 3, y: knobRadius / 3, width: knobRadius * 1.3, height: knobRadius * 1.3)
        knobImage.contentMode = .ScaleAspectFit
        knobView.addSubview(knobImage)
    }
    
    
    // ==============
    // MARK: - LAYOUT
    // ==============
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout Bar
        let x = CGRectGetMidX(bounds) - barLength / 2
        let y = CGRectGetMidY(bounds) - barThickness / 2
        
        let barFrame = CGRectMake(x, y, barLength, barThickness)
        barLayer.frame = barFrame
        
        
        // Layout Knob
        knobView.center.y = CGRectGetMidY(bounds)
        
        if _isInitialLayout {
            knobView.frame.origin.x = on ? onX : offX
            _isInitialLayout = false
        }
    }
    
    
    // ======================
    // MARK: - EVENT HANDLERS
    // ======================
    
    func panned(pan:UIPanGestureRecognizer) {
        let translation = pan.translationInView(self)
        
        switch pan.state {
        case .Began:
            break
        case .Changed:
            if on {
                //Cannot pull knob right
                let x = max(offX, min(translation.x + onX, onX))
                knobView.frame.origin.x = x
            } else {
                //Cannot pull knob left
                let x = min(max(translation.x, offX), onX)
                knobView.frame.origin.x = x
            }
            break
        case .Ended, .Cancelled:
            if on {
                if knobView.frame.origin.x != onX {
                    on = false
                    UIView.animateWithDuration(0.3, animations: {
                        self.knobView.frame.origin.x = self.offX
                    })
                }
            } else {
                if knobView.frame.origin.x != offX {
                    on = true
                    UIView.animateWithDuration(0.3, animations: {
                        self.knobView.frame.origin.x = self.onX
                    })
                }
            }
            break
        default:
            break
        }
    }
    
    func tapped(tap:UITapGestureRecognizer) {
        if tap.state == .Ended {
            on ? (on = false) : (on = true)
            UIView.animateWithDuration(0.3, animations: {
                self.knobView.frame.origin.x = self.on ? self.onX : self.offX
            })
        }
    }
    
    
    // ===============
    // MARK: - HELPERS
    // ===============
    
    private func setKnobSizeFor(radius radius:CGFloat) {
        knobView.frame.size = CGSizeMake(radius * 2, radius * 2)
    }
    
}
