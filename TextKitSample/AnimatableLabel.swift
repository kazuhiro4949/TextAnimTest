//
//  AnimatableLabel.swift
//  TextKitSample
//
//  Created by Kazuhiro Hayashi on 11/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class AnimatableLabel: UILabel {

    var lineRects = [CGRect]()
    var letterPaths = [UIBezierPath]()
    var letterPositions = [CGPoint]()
    var letterFrames = [CGRect]()
    var letterLayer = [CAShapeLayer]()
    var suggestedSize = CGSize.zero
    
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        computeLetterPaths(attrString: attributedText!)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }


}


extension AnimatableLabel {
    func computeLetterPaths(attrString: NSAttributedString) {
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, attrString.string.characters.count), nil, CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude), nil)
        self.suggestedSize = suggestedSize
        let textPath = CGPath(rect: CGRect(origin: CGPoint.zero, size: suggestedSize), transform: nil)
        let textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), textPath, nil)
        
        let lines = CTFrameGetLines(textFrame)
        
        var origins = Array<CGPoint>(repeating: CGPoint.zero, count: CFArrayGetCount(lines as CFArray))
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), &origins)
        
        for var lineIndex in 0..<CFArrayGetCount(lines) {
            let unmergedLine = CFArrayGetValueAtIndex(lines as CFArray, lineIndex)
            let line = unsafeBitCast(unmergedLine, to: CTLine.self)
            var lineOrigin = origins[lineIndex]
            let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useGlyphPathBounds)
            lineRects.append(lineBounds)
            
            
            let runs = CTLineGetGlyphRuns(line)
            for runIndex in 0..<CFArrayGetCount(runs) {
                let runPointer = CFArrayGetValueAtIndex(runs, runIndex)
                let run = unsafeBitCast(runPointer, to: CTRun.self)
                let attributes = CTRunGetAttributes(run)
                
                let fontPointer = CFDictionaryGetValue(attributes, Unmanaged.passRetained(kCTFontAttributeName).toOpaque())
                let font = unsafeBitCast(fontPointer, to: CTFont.self)
                
                let glyphCount = CTRunGetGlyphCount(run)
                
                for glyphIndex in 0..<glyphCount {
                    let glyphRange = CFRangeMake(glyphIndex, 1)
                    var glyph = CGGlyph()
                    var position = CGPoint.zero
                    CTRunGetGlyphs(run, glyphRange, &glyph)
                    CTRunGetPositions(run, glyphRange, &position)
                    print("position: \(position)")
                    position.y = lineOrigin.y
                    
                    //                    var ascents = Array<CGFloat>(repeating: 0, count: glyphCount)
                    //                    var descents = Array<CGFloat>(repeating: 0, count: glyphCount)
                    //                    var leading = Array<CGFloat>(repeating: 0, count: glyphCount)
                    //                    let width = CTRunGetTypographicBounds(run, CFRangeMake(glyphIndex, 1), &ascents, &descents, &leading)
                    
                    //                    print("width: \(width), ascents: \(ascents), descents: \(descents), leading: \(leading)")
                    //                    let height = Double(ascents.first! + descents.first!)
                    //                    letterFrames.append((CGRect(origin: position, size: CGSize(width: width, height: height))))
                    
                    var aRect = CGRect.zero
                    CTFontGetBoundingRectsForGlyphs(font, .default, &glyph, &aRect, 1)
                    
                    let offset = CTLineGetOffsetForStringIndex(line, glyphIndex, nil)
                    
                    aRect.origin.x += offset
                    aRect.origin.y += origins[lineIndex].y
                    letterFrames.append(aRect)
                    print("offset: \(offset)")
                    print("aRect: \(aRect)")
                    print(glyph)
                    if let path = CTFontCreatePathForGlyph(font, glyph, nil) {
                        letterPaths.append(UIBezierPath(cgPath: path))
                        letterPositions.append(position)
                    }
                }
            }
        }
    }
}
