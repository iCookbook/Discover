//
//  DiscoverPresenter.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Common
import Resources

final class DiscoverPresenter: BaseRecipesPresenter {
    weak var view: DiscoverViewInput?
    
    // MARK: - Init
    
    init(router: DiscoverRouterInput, interactor: DiscoverInteractorInput) {
        super.init(router: router, interactor: interactor)
    }
}

extension DiscoverPresenter: DiscoverModuleInput {
}

extension DiscoverPresenter: DiscoverViewOutput {
    
    func requestData(urlString: String?) {
        guard let interactor = interactor as? DiscoverInteractorInput else {
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.somethingWentWrong)
            return
        }
        interactor.provideData(urlString: urlString)
    }
}

extension DiscoverPresenter: DiscoverInteractorOutput {
}
