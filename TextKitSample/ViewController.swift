//
//  ViewController.swift
//  TextKitSample
//
//  Created by Kazuhiro Hayashi on 10/1/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var refLabel: UILabel!
    @IBOutlet weak var aView: UIView!
    
    @IBOutlet weak var label: TextKitLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let attr = NSMutableAttributedString(string: "You gods, will give us. Some faults to make us men.")
//        let range = NSRange(0..<attr.string.characters.count)
//        let attrs: [String: AnyObject] = [NSFontAttributeName: UIFont(name: "Zapfino", size: 17)!]
//        attr.setAttributes(attrs, range: range)
//        label.attributedText = attr
//        
//        refLabel.attributedText = attr
    }
    
    let layer = CATextLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    func tapView(sender: UITapGestureRecognizer) {
        let anim = CABasicAnimation()
        anim.keyPath = "opacity"
        anim.toValue = NSNumber(value: 0)
        anim.duration = 1
        layer.add(anim, forKey: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        let view = TextEffectView(frame: CGRect(x: 50, y: 100, width: 300, height: 200))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "You gods, will give us. Some faults to make us men."
        view.font = UIFont(name: "Zapfino", size: 17)!
        self.view.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50)
        view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)

        view.createGlyphLayer()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
