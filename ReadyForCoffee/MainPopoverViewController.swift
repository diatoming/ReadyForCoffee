//
//  MainPopoverController.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Cocoa

class MainPopoverViewController : NSViewController {

    init?(frame: NSRect) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        //Init view
        self.view = MainPopoverView(frame: NSRect(x: 0, y: 0, width: 300, height: 300))
        
        
        //Layout
        self.view.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(self.view.snp_height)
            make.width.equalTo(self.view.snp_width)
            make.center.equalTo(self.view.snp_center)
        }
    }
    
}