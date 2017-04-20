//
//  PetImage
//  MyLittleMonster
//
//  Created by Mohammad Hemani on 2/27/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation
import UIKit

class PetImage: UIImageView {
    
    private var _type = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //playIdleAnimation()
    }
    
    var type: String {
        get {
            return _type
        } set {
            _type = newValue
            self.playIdleAnimation()
        }
    }
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "\(_type)-idle1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for x in 1...4 {
            let img = UIImage(named: "\(_type)-idle\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "\(_type)-dead5.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for x in 1...5 {
            let img = UIImage(named: "\(_type)-dead\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
    func playRebornAnimation() {
        
        self.image = UIImage(named: "\(_type)-dead1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for x in (1...5).reversed() {
            let img = UIImage(named: "\(_type)-dead\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 2
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
}
