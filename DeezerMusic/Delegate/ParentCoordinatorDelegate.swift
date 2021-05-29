//
//  ParentCoordinatorDelegate.swift
//  DeezerMusic
//
//  Created by Zvonimir Medak on 27/05/2020.
//  Copyright © 2020 Zvonimir Medak. All rights reserved.
//

import Foundation
protocol ParentCoordinatorDelegate: class {
    func childHasFinished(coordinator: Coordinator)
}
