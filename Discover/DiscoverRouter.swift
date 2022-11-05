//
//  DiscoverRouter.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Models
import RecipeDetails

final class DiscoverRouter {
    weak var output: DiscoverRouterOutput?
    weak var viewController: UIViewController?
}

extension DiscoverRouter: DiscoverRouterInput {
    func openRecipeDetailsModule(for recipe: Recipe) {
        let context = RecipeDetailsContext(moduleOutput: self, recipe: recipe)
        let assembly = RecipeDetailsAssembly.assemble(with: context)
        viewController?.navigationController?.pushViewController(assembly.viewController, animated: true)
    }
}

extension DiscoverRouter: RecipeDetailsModuleOutput {
}
