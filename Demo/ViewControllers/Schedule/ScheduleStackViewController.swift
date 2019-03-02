//
//  APIViewController.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang

class ScheduleStackedViewController: UIViewController, ViewModelCompatible, InteractionCompatible {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: ScheduleViewModel) {
        stackView.boomerang.configure(with: viewModel)
    }
}
