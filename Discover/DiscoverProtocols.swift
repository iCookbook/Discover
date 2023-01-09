//
//  DiscoverProtocols.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//

import Common
import Networking

public protocol DiscoverDependenciesProtocol {
    var moduleOutput: DiscoverModuleOutput? { get set }
    var networkManager: NetworkManagerProtocol { get }
}

public protocol DiscoverModuleInput: BaseRecipesModuleInput {
}

public protocol DiscoverModuleOutput: BaseRecipesModuleOutput {
}

protocol DiscoverViewInput: BaseRecipesViewInput {
}

protocol DiscoverViewOutput: BaseRecipesViewOutput {
}

protocol DiscoverInteractorInput: BaseRecipesInteractorInput {
}

protocol DiscoverInteractorOutput: BaseRecipesInteractorOutput {
}

protocol DiscoverRouterInput: BaseRecipesRouterInput {
}

protocol DiscoverRouterOutput: BaseRecipesModuleOutput {
}
