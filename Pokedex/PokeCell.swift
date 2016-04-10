//
//  PokeCell.swift
//  Pokedex
//
//  Created by Matthew Bracamonte on 4/9/16.
//  Copyright © 2016 Matthew Bracamonte. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon:Pokemon) {
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalizedString
        pokemonImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
