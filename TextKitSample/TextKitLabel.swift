//
//  TextKitLabel.swift
//  TextKitSample
//
//  Created by Kazuhiro Hayashi on 10/1/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit


class TextKitLabel: UILabel, NSLayoutManagerDelegate, CAAnimationDelegate {

    let layoutManager = NSLayoutManager()
    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    
    var selectedRange: CountableClosedRange<Int> = (0...1)
    
    override var text: String? {
        didSet {
            guard let text = text else {
                attributedText = nil
                return
            }
            let range = NSRange(0..<text.characters.count)

            let mutableAttributedString = NSMutableAttributedString(string: text)
            mutableAttributedString.addAttribute(NSFontAttributeName, value: font, range: range)
            mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
            let style = NSMutableParagraphStyle()
            style.alignment = textAlignment
            mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            textStorage.setAttributedString(attributedText!)
        }
    }
    
    func stringFromText() -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        let range = NSRange(0..<text.characters.count)
        
        let mutableAttributedString = NSMutableAttributedString(string: text)
        mutableAttributedString.addAttribute(NSFontAttributeName, value: font, range: range)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        return mutableAttributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        attributedText = stringFromText()
        
        textStorage.setAttributedString(attributedText!)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = .byTruncatingTail
        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self
    }

//    override func drawText(in rect: CGRect) {
//    }
    
    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        layoutManager.drawBackground(forGlyphRange: NSRange(0..<textStorage.length), at: CGPoint(x: 0, y: 0))
//        layoutManager.drawGlyphs(forGlyphRange: NSRange(0..<textStorage.length), at: CGPoint(x: 0, y: 0))
        textLayers.forEach { $0.removeFromSuperlayer() }
        textLayers = []
        setupLayer()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        var shaffleLayers = textLayers
        for index in 0..<shaffleLayers.count {
            let newIndex = Int(arc4random_uniform(UInt32(shaffleLayers.count - 1)))
            if index != newIndex {
                swap(&shaffleLayers[index], &shaffleLayers[newIndex])
            }
        }
        
        falldown(shaffleLayers: shaffleLayers)
//        scaleDown(shaffleLayers: shaffleLayers)
//        fadeout(shafflelayers: shaffleLayers)
//        floating(shaffleLayers: shaffleLayers)
    }
    
    private func fadeout(shafflelayers: [CATextLayer]) {
        shafflelayers.enumerated().forEach { (index, layer) in
            let anim = CABasicAnimation()
            anim.keyPath = "opacity"
            anim.toValue = 0
            anim.duration = CFTimeInterval(0.5)
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            anim.isRemovedOnCompletion = false
            anim.fillMode = kCAFillModeForwards
            layer.add(anim, forKey: "opacity")
        }
    }
    
    private func falldown(shaffleLayers: [CATextLayer]) {
        shaffleLayers.enumerated().forEach { (index, layer) in
            let anim = CABasicAnimation(keyPath: "position")
            var newPoint = layer.position
            newPoint.y += 50
            anim.toValue = NSValue(cgPoint: newPoint)
            
            let colorAnim = CABasicAnimation(keyPath: "opacity")
            colorAnim.toValue = NSNumber(value: 0)
            
            let arc: Double =  M_PI * (-500 + Double(arc4random_uniform(1000))) / 1000
            let translateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
            translateAnim.toValue = NSNumber(value: arc)
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = CFTimeInterval(0.5)
            groupAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
            groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            groupAnim.isRemovedOnCompletion = false
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.animations = [anim, colorAnim, translateAnim]
            
            layer.add(groupAnim, forKey: "group")
        }
    }
    
    private func scaleDown(shaffleLayers: [CATextLayer]) {
        shaffleLayers.enumerated().forEach { (index, layer) in
            let anim = CABasicAnimation()
            anim.keyPath = "transform.scale"
            anim.toValue = 1.5

            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.toValue = 0
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.5
            groupAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.02)
            groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            groupAnim.isRemovedOnCompletion = false
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.animations = [anim, opacityAnim]
            
            layer.add(groupAnim, forKey: "transform.scale")
        }
    }
    
    private func floating(shaffleLayers: [CATextLayer]) {
        shaffleLayers.enumerated().forEach { (index, layer) in
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.toValue = 0
            anim.repeatCount = MAXFLOAT
            anim.isCumulative = true
            anim.duration = 0.5
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * CFTimeInterval(0.5)
            layer.add(anim, forKey: "")
        }
    }
    
    var textLayers = [CATextLayer]()
    
    func setupLayer() {
        let charNum: Int = attributedText?.string.characters.count ?? 0
        var index: Int = 0

        while index < charNum {
            var glyphRagen = NSRange()
            let range = layoutManager.characterRange(forGlyphRange: NSRange(index..<index+1), actualGlyphRange: &glyphRagen)
            var glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRagen, in: textContainer)
            
            let spaceRange = layoutManager.range(ofNominallySpacedGlyphsContaining: glyphRagen.location)
            
            let layoutRect = layoutManager.usedRect(for: textContainer)
            let gryphPosition = layoutManager.location(forGlyphAt: index)
            glyphRect.origin.y += (gryphPosition.y - glyphRect.height/2) + (bounds.size.height/2 - layoutRect.height/2)
            
//            print("charRange: \(range.location)..\(range.length)")
//            print("glyphRange: \(glyphRagen.location)..\(glyphRagen.length)")
//            print("spaceRange: \(spaceRange.location)..\(spaceRange.length)")
//            print("glyphRect: \(glyphRect)")
            
            if let prevLayer = textLayers.last,
                spaceRange.length > 1 && spaceRange.location == index && textLayers.count != 0 {
                prevLayer.frame.size.width += glyphRect.maxX - prevLayer.frame.maxX
            }
            
            
            
            
            if NSEqualRanges(glyphRagen, layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: index)) {
                let layer = CATextLayer()
                layer.contentsScale = traitCollection.displayScale
                layer.font = font
                layer.fontSize = font.pointSize
                layer.string = NSAttributedString(string: "…")
                layer.frame = glyphRect
                textLayers.append(layer)
                self.layer.addSublayer(layer)
            } else {
                let layer = CATextLayer()
                layer.contentsScale = traitCollection.displayScale
                layer.string = attributedText?.attributedSubstring(from: range)
                layer.frame = glyphRect
                layer.font = font
                layer.fontSize = font.pointSize
                textLayers.append(layer)
                self.layer.addSublayer(layer)
            }
            setNeedsDisplay()
            index += range.length
        }
    }
}
