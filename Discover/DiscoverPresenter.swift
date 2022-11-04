//
//  DiscoverPresenter.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Models
import Networking
import Resources

final class DiscoverPresenter {
    weak var view: DiscoverViewInput?
    weak var moduleOutput: DiscoverModuleOutput?
    
    // MARK: - Private Properties
    
    private let router: DiscoverRouterInput
    private let interactor: DiscoverInteractorInput
    
    // MARK: - Init
    
    init(router: DiscoverRouterInput, interactor: DiscoverInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension DiscoverPresenter: DiscoverModuleInput {
}

extension DiscoverPresenter: DiscoverViewOutput {
    func requestData(urlString: String?) {
        interactor.requestData(urlString: urlString)
    }
    
    func didSelectRecipe(_ recipe: Recipe) {
        router.openRecipeDetailsModule(for: recipe)
    }
}

extension DiscoverPresenter: DiscoverInteractorOutput {
    func provideResponse(_ response: Response) {
        guard let hits = response.hits else { return }
        var recipes = [Recipe]()
        
        for hit in hits {
            if let recipe = hit.recipe {
                recipes.append(recipe)
            }
        }
        view?.fillData(with: recipes, nextPageUrl: response.links?.next?.href)
    }
    
    func handleError(_ error: NetworkManagerError) {
        switch error {
        case .invalidURL:
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.restartApp)
        case .retainCycle:
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.restartApp)
        case .networkError(let error):
            view?.showAlert(title: Texts.Errors.oops, message: "\(error.localizedDescription)")
        case .parsingJSONError:
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.somethingWentWrong)
        }
    }
}
