//
//  AppCoordinator.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 27/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
import UIKit
class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow){
        self.window = window
    }
    
    deinit {
        print("appCo")
    }
    
    func start() {
        window.rootViewController = UINavigationController(rootViewController: HomeScreenViewController(viewModel: HomeScreenViewModelImpl(songRepository: SongRepositoryImpl())))
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: CoordinatorDelegate{    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        removeChildCoordinator(coordinator: self)
    }
}
