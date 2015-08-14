//
//  AppDelegate.swift
//  ReadyForCoffee
//
//  Created by Kevin Skyba on 13.08.15.
//  Copyright (c) 2015 Kevin Skyba. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        //Setup statusItem
        if let button = statusItem.button {
            button.image = NSImage(named: "Coffee")
            button.action = Selector("togglePopover:")
        }
        
        //Setup popover
        popover.contentViewController = MainPopoverViewController(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSMinYEdge)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

