//
//  EffectLabel.swift
//  TextKitSample
//
//  Created by Kazuhiro Hayashi on 11/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class EffectLabel: UIView {

    var text: String?
    var font: UIFont?
    var textColor: UIColor?
    var textAlignment: NSTextAlignment = .left
    var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    var isEnabled: Bool = true
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .redraw
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
