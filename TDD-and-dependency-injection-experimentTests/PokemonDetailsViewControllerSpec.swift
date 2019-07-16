import Foundation
import Quick
import Nimble
import Spry_Nimble
import SwiftyJSON

@testable import TDD_and_dependency_injection_experiment

class PokemonDetailsViewControllerSpec: QuickSpec {
  override func spec() {
    describe("PokemonDetailsViewControllerSpec") {
      var subject: PokemonDetailsViewController!
      
      beforeEach {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        subject = (storyboard.instantiateViewController(withIdentifier: "PokemonDetailsViewController") as! PokemonDetailsViewController)
        subject.loadView()
        apiWrapper.resetCalls()
      }
      
      describe("viewDidLoad") {
        it("should fetch a single pokemon by name") {
          subject.pokemon = Pokemon(json: JSON(["name": "bulbasaur"]))
          subject.viewDidLoad()
          
          expect(apiWrapper).to(haveReceived(.getPokemonWith, with: "bulbasaur"))
        }
      }
    }
  }
}
