//
//  DiscoverRouter.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Models

final class DiscoverRouter {
    weak var output: DiscoverRouterOutput?
    weak var viewController: UIViewController?
}

extension DiscoverRouter: DiscoverRouterInput {
    
    func openRecipeDetailsModule(for recipe: Recipe) {
        
    }
}
