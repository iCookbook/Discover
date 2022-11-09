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
    func requestRandomData() {
        interactor.provideRandomData()
    }
    
    func requestData(urlString: String?) {
        interactor.provideData(urlString: urlString)
    }
    
    func didSelectRecipe(_ recipe: Recipe) {
        router.openRecipeDetailsModule(for: recipe)
    }
}

extension DiscoverPresenter: DiscoverInteractorOutput {
    /// Provides response from the interactor.
    /// - Parameters:
    ///   - response: ``Response`` got from the server.
    ///   - withOverridingCurrentData: defines whether this data show override current one. This is necessary for handling requesting random data (`true`) and data by provided url (`false`).
    func provideResponse(_ response: Response, withOverridingCurrentData: Bool) {
        var recipes = [Recipe]()
        
        guard let hits = response.hits else {
            handleError(.parsingJSONError)
            return
        }
        
        for hit in hits {
            guard let recipe = hit.recipe else {
                handleError(.parsingJSONError)
                return
            }
            recipes.append(recipe)
        }
        view?.fillData(with: recipes, nextPageUrl: response.links?.next?.href, withOverridingCurrentData: withOverridingCurrentData)
    }
    
    /// Provides data to show in alerts according to provided `error`.
    /// - Parameter error: ``NetworkManagerError`` error instance.
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
