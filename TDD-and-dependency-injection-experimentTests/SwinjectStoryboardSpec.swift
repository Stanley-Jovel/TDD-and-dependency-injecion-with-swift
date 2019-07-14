import Foundation
import Swinject
import SwinjectStoryboard
import RxSwift
import SwiftyJSON

@testable import TDD_and_dependency_injection_experiment

var apiWrapper = FakeApiWrapper()
extension SwinjectStoryboard {
  @objc class func setup() {
    apiWrapper.stub(.getAllPokemons).andReturn(Observable<[Pokemon]>.empty())
    
    defaultContainer.storyboardInitCompleted(PokemonListViewController.self, initCompleted: {(r, vc) in
      vc.apiWrapper = apiWrapper
    })
  }
}
