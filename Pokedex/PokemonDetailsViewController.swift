//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Matthew Bracamonte on 4/13/16.
//  Copyright © 2016 Matthew Bracamonte. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLvl: UILabel!
    @IBOutlet weak var nextEvolutionLbl: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    var musicPlayer: AVAudioPlayer!
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalizedString
        let mainImg = UIImage(named: "\(pokemon.pokedexId)")
        pokemonImg.image = mainImg
        currentEvoImg.image = mainImg
        
        initAudio()
        
        pokemon.didCompleteDownload {
            self.updateUI()
        }
    }
    
    
    @IBAction func backButtonPressed(sender: UIButton) {
        musicPlayer.stop()
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("finalroad", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL (string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexIDLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        baseAttackLvl.text = pokemon.baseAttack
        
        if pokemon.nextEvolutionLvl == "" && pokemon.stoneEvo == "" {
            nextEvolutionLbl.text = "NO EVOLUTION LVL"
            nextEvoImg.hidden = true
        } else if pokemon.nextEvolutionLvl != "" || pokemon.stoneEvo != "" {
            if pokemon.nextEvolutionLvl != "" {
                nextEvolutionLbl.text = "Next Evolution \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLvl)"
                nextEvoImg.hidden = false
                nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            } else {
                nextEvolutionLbl.text = "Next Evolution \(pokemon.nextEvolutionName) - \(pokemon.stoneEvo.capitalizedString)"
                nextEvoImg.hidden = false
                nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            }
        }
    }
    
    @IBAction func segmentControlPressed(sender: UISegmentedControl) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            descriptionLbl.text = pokemon.description
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            descriptionLbl.text = pokemon.pokemonMove
        }
    }
    
    
    
    
}

