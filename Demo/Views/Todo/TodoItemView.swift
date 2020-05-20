//
//  TodoItemView.swift
//  Demo
//
//  Created by Andrea Bellotto on 18/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

class TodoItemView: UIView, WithViewModel {
    @IBOutlet weak var todoLabel: UILabel!
 
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? TodoViewModel else { return }
        self.todoLabel.text = viewModel.todo
    }
}
