//
//  Pokemon.swift
//  Pokedex
//
//  Created by Matthew Bracamonte on 4/9/16.
//  Copyright © 2016 Matthew Bracamonte. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    private var _pokemonMove: String!
    private var _stoneEvo: String!
    
    var stoneEvo: String {
        if _stoneEvo == nil {
            _stoneEvo = ""
        }
        return _stoneEvo
    }
    
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var pokemonMove: String {
        if _pokemonMove == nil {
            _pokemonMove = ""
        }
        return _pokemonMove
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func didCompleteDownload(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET,url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                print(self._baseAttack)
                print(self._weight)
                print(self._height)
                print(self._defense)
                
                if let moves = dict["moves"] as? [Dictionary<String,AnyObject>] where moves.count > 0 {
                    if let name = moves[0]["name"] as? String {
                        self._pokemonMove = name
                    }
                    if moves.count > 1 {
                        for x in 1..<moves.count {
                            if let name = moves[x]["name"] {
                                self._pokemonMove! += ", \(name)"
                            }
                        }
                    }
                } else {
                    self._pokemonMove = ""
                }
                print(self._pokemonMove)

                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
                
                if let descArray = dict["descriptions"] as? [Dictionary<String,String>] where descArray.count > 0 {
                    if let uri = descArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(uri)")!
                        Alamofire.request(.GET,nsurl).responseJSON { response in
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String,AnyObject> {
                                if let description = descDict["description"] as? String {
                                self._description = description
                                    print(self._description)
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionName = to
                                
                                if let nextLevel = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(nextLevel)"
                                    print(self._nextEvolutionLvl)
                                } else {
                                    let stone = evolutions[0]["method"] as? String
                                    self._stoneEvo = stone
                                    print(self._stoneEvo)
                                }
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionName)
                            
                            }
                        }
                    }
                }
//                completed()
            }
        }
    }
}