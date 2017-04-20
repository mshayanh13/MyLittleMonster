//
//  GameController.swift
//  MyLittleMonster
//
//  Created by Mohammad Hemani on 2/27/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import AVFoundation

class GameController: UIViewController {

    var petType: String!
    var imageToDisplay: UIImage!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var petImage: PetImage!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var obedienceImage: DragImage!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    @IBOutlet weak var retryButton: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: Timer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = imageToDisplay
        petImage.type = petType
        
        foodImage.dropTarget = petImage
        heartImage.dropTarget = petImage
        obedienceImage.dropTarget = petImage
        
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameController.itemDroppedOnCharacter(notif:)), name: NSNotification.Name(rawValue: "onTargetDropped"),object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
        
    }
    
    @IBAction func retryTapped(sender: UIButton) {
        retryButton.isHidden = true
        
        penalties = 0
        currentItem = 0
        monsterHappy = false
        
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA
        
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        
        petImage.playRebornAnimation()

        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GameController.begin), userInfo: nil, repeats: false)

        
    }

    func begin() {
        
        petImage.playIdleAnimation()
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: Any) {
        
        monsterHappy = true
        startTimer()
        
        heartImage.alpha = DIM_ALPHA
        heartImage.isUserInteractionEnabled = false
        foodImage.alpha = DIM_ALPHA
        foodImage.isUserInteractionEnabled = false
        obedienceImage.alpha = DIM_ALPHA
        obedienceImage.isUserInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Image.alpha = OPAQUE
                penalty2Image.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Image.alpha = OPAQUE
                penalty3Image.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Image.alpha = OPAQUE
            } else {
                penalty1Image.alpha = DIM_ALPHA
                penalty2Image.alpha = DIM_ALPHA
                penalty3Image.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        
        let rand = arc4random_uniform(3) // 0 or 1 or 2
        
        if rand == 0 {
            heartImage.alpha = OPAQUE
            heartImage.isUserInteractionEnabled = true
            
            foodImage.alpha = DIM_ALPHA
            foodImage.isUserInteractionEnabled = false
            
            obedienceImage.alpha = DIM_ALPHA
            obedienceImage.isUserInteractionEnabled = false
            
        } else if rand == 1 {
            heartImage.alpha = DIM_ALPHA
            heartImage.isUserInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.isUserInteractionEnabled = true
            
            obedienceImage.alpha = DIM_ALPHA
            obedienceImage.isUserInteractionEnabled = false
            
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.isUserInteractionEnabled = false
            
            foodImage.alpha = DIM_ALPHA
            foodImage.isUserInteractionEnabled = false
            
            obedienceImage.alpha = OPAQUE
            obedienceImage.isUserInteractionEnabled = true
            
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        petImage.playDeathAnimation()
        if musicPlayer.isPlaying {
            musicPlayer.stop()
        }
        sfxDeath.play()
        retryButton.isHidden = false
    }
    
}

