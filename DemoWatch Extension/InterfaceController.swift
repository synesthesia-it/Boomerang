//
//  InterfaceController.swift
//  DemoWatch Extension
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import WatchKit
import Foundation
import Boomerang
import RxSwift
import RxCocoa

typealias Image = WKImage

class InterfaceController: WKInterfaceController {
    let viewModel = ScheduleViewModel()
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        (table as? ViewModelCompatibleType)?.set(viewModel: viewModel)
        viewModel.load()
        
//        table.set(viewModel: viewModel)
//        table.setNumberOfRows(test.count, withRowType: "ShowRowController")
//        test.enumerated().forEach {
//            (table.rowController(at: $0.offset) as? ShowRowController)?.text = $0.element
//        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

