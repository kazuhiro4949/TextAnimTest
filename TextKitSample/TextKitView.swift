//
//  TextKitView.swift
//  TextKitSample
//
//  Created by Kazuhiro Hayashi on 10/1/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class TextKitView: UIView, NSLayoutManagerDelegate {

    let layoutManager = NSLayoutManager()
    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer()
    
    var selectedRange: CountableClosedRange<Int> = (0...1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attrText = NSAttributedString(string: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        textStorage.setAttributedString(attrText)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byTruncatingTail
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self
    }
    
    override func draw(_ rect: CGRect) {
        layoutManager.drawBackground(forGlyphRange: NSRange(0..<textStorage.length), at: CGPoint(x: 0, y: 0))
        layoutManager.drawGlyphs(forGlyphRange: NSRange(0..<textStorage.length), at: CGPoint(x: 0, y: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let location = touches.first?.location(in: self) else {
            fatalError("touch error")
        }
        
//        print(layoutManager.usedRect(for: textContainer))
        
        
        layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(for: textContainer)) { (a) in
//            print(a)
            
        }
        
        textStorage.removeAttribute(NSBackgroundColorAttributeName, range: NSRange(0..<textStorage.length))
        
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//        print(index)
        selectedRange = (index...index)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            fatalError("touch error")
        }
        
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let lowerBounds = selectedRange.lowerBound
        let upperBounds = selectedRange.upperBound
        
        let range = NSRange(location: selectedRange.lowerBound,length: selectedRange.upperBound + 1 - selectedRange.lowerBound)
        textStorage.removeAttribute(NSBackgroundColorAttributeName, range: range)
        
        if  upperBounds <= index {
            selectedRange = lowerBounds...index
        } else if lowerBounds < index && index < upperBounds {
            selectedRange = lowerBounds...index
        } else if index <= lowerBounds {
            selectedRange = index...lowerBounds
        }
        

        let newRange = NSRange(location: selectedRange.lowerBound,length: selectedRange.upperBound + 1 - selectedRange.lowerBound)
        textStorage.addAttributes([NSBackgroundColorAttributeName: UIColor.red], range: newRange)
        setNeedsDisplay()
        print(selectedRange)
//        textStorage.invalidateAttributes(in: range)
    }
    


    
}
