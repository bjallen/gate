//
//  ViewController.swift
//  Gate Opener
//
//  Created by B.J. Allen on 7/27/14.
//  Copyright (c) 2014 Fourth Valve. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let host = NSUserDefaults.standardUserDefaults().stringForKey("host_preference")
    @IBOutlet weak var gateButton: UIButton!
    @IBOutlet weak var problemButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        problemButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func gateButtonPressed() {
        gateButton.selected = true
        let urlString: String = "\(host)/run"
        var url = NSURL(string: urlString)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 5
        let queue: NSOperationQueue = NSOperationQueue.mainQueue()

        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { [weak self]
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in

            if let actualSelf = self {
                if error {
                    actualSelf.gateTriggerFailed()
                }

                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        actualSelf.gateTriggerSucceeded()
                    }
                    else {
                        actualSelf.gateTriggerFailed()
                    }

                }
                actualSelf.gateButton.selected = false
            }
        })
    }

    @IBAction func problemButtonPressed() {
        problemButton.selected = true
        let urlString: String = "\(host)/check"
        var url = NSURL(string: urlString)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.timeoutInterval = 2
        let queue:NSOperationQueue = NSOperationQueue.mainQueue()

        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { [weak self]
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in

            if let actualSelf = self {
                if error {
                    actualSelf.healthCheckFailed()
                }

                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        actualSelf.healthCheckSucceeded()
                    }
                    else {
                        actualSelf.healthCheckFailed()
                    }

                }
                actualSelf.problemButton.selected = false
            }
        })
    }


    func gateTriggerSucceeded() {
        showGateButton()
    }

    func gateTriggerFailed() {
        showProblemButton()
    }

    func healthCheckSucceeded() {
        showGateButton()
    }

    func healthCheckFailed() {
        showProblemButton()
    }

    func showProblemButton() {
        gateButton.selected = false
        gateButton.enabled = false
        gateButton.hidden = true

        problemButton.selected = false
        problemButton.enabled = true
        problemButton.hidden = false
    }

    func showGateButton() {
        gateButton.selected = false
        gateButton.enabled = true
        gateButton.hidden = false

        problemButton.selected = false
        problemButton.enabled = false
        problemButton.hidden = true
    }
}
