//
//  Pokemon.swift
//  Custom Assigment 7
//
//  Created by Stanley on 6/28/19.
//  Copyright © 2019 Stanley. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pokemon {
  var name: String?
  var sprite: String?
  var types: [String]?
  var abilities: [String]?
  var moves: [String]?
  
  init(json: JSON) {
    self.name = json["name"].string
    self.sprite = json["sprites"]["front_default"].string
    self.types = Pokemon.parse(trait: "type", from: json["types"])
    self.abilities = Pokemon.parse(trait: "ability", from: json["abilities"])
    self.moves = Pokemon.parse(trait: "move", from: json["moves"])
  }
  
  static func parse(trait traitName: String, from json: JSON) -> [String] {
    guard let traits = json.array else {
      return []
    }
    
    return traits.map { trait in
      return trait[traitName]["name"].string ?? ""
    }
  }
}
