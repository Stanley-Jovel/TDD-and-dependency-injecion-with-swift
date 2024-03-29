import Foundation
import Spry
import RxSwift
import SwiftyJSON

@testable import TDD_and_dependency_injection_experiment

class FakeApiWrapper: ApiWrapper, Spryable {
  enum ClassFunction: String, StringRepresentable {
    case none = "none"
  }
  
  enum Function: String, StringRepresentable {
    case getAllPokemons = "getAllPokemons()"
    case getPokemonWith = "getPokemonWith(id:)"
  }
  
  override func getAllPokemons() -> Observable<[Pokemon]> {
    return spryify()
  }
  
  override func getPokemonWith(id pokemonId: String) -> Single<Pokemon> {
    return spryify(arguments: pokemonId)
  }
}
