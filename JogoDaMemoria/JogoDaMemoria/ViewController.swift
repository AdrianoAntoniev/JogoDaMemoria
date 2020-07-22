//
//  ViewController.swift
//  JogoDaMemoria
//
//  Created by Adriano Rodrigues Vieira on 17/07/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var turnsLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    
    var turns: Int = 0 {
        didSet {
            turnsLabel.text = "Jogadas: \(turns)"
        }
    }
    @IBOutlet weak var goalsLabel: UILabel!
    var goals: Int = 0 {
        didSet {
            goalsLabel.text = "Acertos: \(goals)"
        }
    }
    var clicks: Int = 0
    var previousCard: UIButton?
    var images: [String] = ["💀", "💀", "🤪", "🤪", "🎃", "🎃", "😺", "😺", "🧛🏻‍♂️", "🧛🏻‍♂️",
                            "🦆", "🦆", "🦉", "🦉", "🕸", "🕸", "🌚", "🌚", "☃️", "☃️"]
    @IBOutlet var cards: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winLabel.isHidden = true
        //images.shuffle()
        turnAllCards(toUp: false)
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            self.turnAllCards(toUp: true)
        }
    }
    
    func turnAllCards(toUp faceCardIsUp: Bool) {
        cards.forEach { (card) in
            self.flipCard(currentCard: card, faceCardIsUp: faceCardIsUp)
        }
    }
    
    
    func flipCard(currentCard card: UIButton, faceCardIsUp: Bool) {
        if faceCardIsUp {
            card.setTitle("", for: .normal)
            card.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            let emoji = images[card.tag - 1]
            card.setTitle(emoji, for: .normal)
            card.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    func winnerMessage(iHaveToShow: Bool) {
        if iHaveToShow {
            winLabel.isHidden = false
            winLabel.text = "Parabéns!"
        }
    }
    
    @IBAction func cardPressed(_ card: UIButton) {
        clicks += 1
        let faceCardIsUp = card.currentTitle != "" // Se o titulo esta em branco, significa que a carta esta virada.
        
        if clicks <= 2 {
            flipCard(currentCard: card, faceCardIsUp: faceCardIsUp)
            
            if clicks == 2 {
                Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (timer) in
                    let cardHasSameImage = card.currentTitle == self.previousCard!.currentTitle
                    
                    if !faceCardIsUp {
                        if cardHasSameImage {
                            card.isHidden = true
                            self.previousCard!.isHidden = true
                            self.goals += 1
                            
                            if self.goals == 10 {
                                self.winnerMessage(iHaveToShow: true)
                            }
                            
                        } else {
                            self.flipCard(currentCard: card, faceCardIsUp: true)
                            self.flipCard(currentCard: self.previousCard!, faceCardIsUp: true)
                        }
                        self.turns += 1
                    }
                    self.clicks = 0
                }
            } else {
                previousCard = card
            }
        }
    }
}

