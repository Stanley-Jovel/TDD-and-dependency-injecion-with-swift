import Foundation
import Quick
import Nimble
import Spry_Nimble
import RxSwift
import SwiftyJSON

@testable import TDD_and_dependency_injection_experiment

class ViewControllerSpec: QuickSpec {
  override func spec() {
    describe("ViewController") {
      var subject: PokemonListViewController!
      
      beforeEach {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        subject = (storyboard.instantiateViewController(withIdentifier: "PokemonListViewController") as! PokemonListViewController)
        subject.loadView()
        apiWrapper.resetCalls()
        print("stop")
      }
      
      describe("viewDidLoad") {
        it("should fetch all pokemons") {
          subject.viewDidLoad()
          
          expect(apiWrapper).to(haveReceived(.getAllPokemons))
        }
      }
    }
  }
}
