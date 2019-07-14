//
//  PokemonSpec.swift
//  TDD-and-dependency-injection-experimentTests
//
//  Created by Luis Stanley Jovel on 7/14/19.
//  Copyright © 2019 stanley jovel. All rights reserved.
//

import Foundation
import Quick
import SwiftyJSON
import Nimble

@testable import TDD_and_dependency_injection_experiment

class PokemonSpec: QuickSpec {
  override func spec() {
    describe("Pokemon Model") {
      describe("init") {
        it("should create a Pokemon instance given a json response from the api") {
          let pokemonResponse = JSON([
            "name": "bulbasaur",
            "sprites": ["front_default": "sprite_url"],
            "types": [
              ["type": [ "name": "type 1"]]
            ],
            "moves": [
              ["move": [ "name": "move 1"]]
            ],
            "abilities": [
              ["ability": [ "name": "ability 1"]]
            ]
          ])
          
          let pokemon = Pokemon(json: pokemonResponse)
          
          expect(pokemon.name).to(equal("bulbasaur"))
          expect(pokemon.sprite).to(equal("sprite_url"))
          expect(pokemon.types).to(equal(["type 1"]))
          expect(pokemon.moves).to(equal(["move 1"]))
          expect(pokemon.abilities).to(equal(["ability 1"]))
        }
      }
      
      describe("parseTraits") {
        it("should parse a JSON array of pokemon traits into an array of String values") {
          let pokemonTypes = JSON([
              ["type": [ "name": "type 1"]],
              ["type": [ "name": "type 2"]],
              ["type": [ "name": "type 3"]]
          ])
          expect(Pokemon.parse(trait: "type", from: pokemonTypes)).to(equal(["type 1", "type 2", "type 3"]))
          
          let pokemonMoves = JSON([
            ["move": [ "name": "move 1"]],
            ["move": [ "name": "move 2"]],
            ["move": [ "name": "move 3"]]
          ])
          expect(Pokemon.parse(trait: "move", from: pokemonMoves)).to(equal(["move 1", "move 2", "move 3"]))
        }
      }
    }
  }
}
