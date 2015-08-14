//
//  ViewController.swift
//  ReadyForCoffeeTestApp
//
//  Created by Kevin Skyba on 14.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import UIKit
import Bond

class MainViewController: UIViewController {

    //MARK: - Public Properties
    @IBOutlet var statusLabel : UILabel?
    @IBOutlet var readySwitch : UISwitch?
    
    //MARK: - Private Properties
    
    private var viewModel : MainViewModel?
    
    //MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        
        //Setup DataBinding
        self.setupDataBinding()
    }
    
    @IBAction func readySwitchChanged(sender: UISwitch) {
        viewModel!.isReadyForCoffee.value = (sender.on ? CoffeeStatus.Ready : CoffeeStatus.NotReady)
    }
    
    //MARK: - Private Methods
    
    private func setupDataBinding() {

        self.viewModel!.status ->> statusLabel!.dynText
        
    }

}

