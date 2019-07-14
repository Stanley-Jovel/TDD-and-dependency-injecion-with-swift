//
//  Pokemon.swift
//  Custom Assigment 7
//
//  Created by Stanley on 6/28/19.
//  Copyright © 2019 Stanley. All rights reserved.
//

import Foundation

class Pokemon {
  var name: String?
  var sprite: String?
  var types: [String]?
  var abilities: [String]?
  var moves: [String]?
  
  init(name: String?) {
    self.name = name
  }
}
