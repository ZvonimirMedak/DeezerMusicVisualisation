//
//  HomeScreenCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 26/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class HomeScreenCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var homeScreenController: UIViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        homeScreenController = createHomeScreenViewController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(homeScreenController, animated: true)
    }

    func createHomeScreenViewController() -> HomeScreenViewController{
        let viewModel = HomeScreenViewModelImpl(songRepository: SongRepositoryImpl())
        let viewController = HomeScreenViewController(viewModel: viewModel)
        return viewController
    }
}
extension HomeScreenCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}

protocol DetailDelegate: class{
    func show()
}

extension HomeScreenCoordinator: DetailDelegate{
    func show(){
    }
}
