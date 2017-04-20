//
//  DragImage.swift
//  MyLittleMonster
//
//  Created by Mohammad Hemani on 2/27/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView {
    
    var originalPosition: CGPoint!
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        originalPosition = self.center
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first, let target = dropTarget {
            
            let position = touch.location(in: self.superview?.superview)
            
            if target.frame.contains(position) {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
                
            }
            
        }
        
        self.center = originalPosition
        
        
    }
}
