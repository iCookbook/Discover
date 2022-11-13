//
//  DiscoverProtocols.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Common

public protocol DiscoverModuleInput: BaseRecipesModuleInput {
}

public protocol DiscoverModuleOutput: BaseRecipesModuleOutput {
}

protocol DiscoverViewInput: BaseRecipesViewInput {
}

protocol DiscoverViewOutput: BaseRecipesViewOutput {
    func requestData(urlString: String?)
}

protocol DiscoverInteractorInput: BaseRecipesInteractorInput {
    func provideData(urlString: String?)
}

protocol DiscoverInteractorOutput: BaseRecipesInteractorOutput {
}

protocol DiscoverRouterInput: BaseRecipesRouterInput {
}

protocol DiscoverRouterOutput: BaseRecipesModuleOutput {
}
