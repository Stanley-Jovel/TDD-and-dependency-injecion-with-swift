import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
  @objc class func setup() {
    defaultContainer.register(ApiWrapper.self, factory: { _ in ApiWrapper() })
    defaultContainer.storyboardInitCompleted(PokemonListViewController.self, initCompleted: { (r, vc) in
      vc.apiWrapper = r.resolve(ApiWrapper.self)
    })
    defaultContainer.storyboardInitCompleted(PokemonDetailsViewController.self, initCompleted: { (r, vc) in
      vc.apiWrapper = r.resolve(ApiWrapper.self)
    })
  }
}
