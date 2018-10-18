//
//  DashboardViewController.swift
//  LDOLayoutTemplates Example
//
//  Created by Sebastian Ludwig on 14.10.18.
//  Copyright © 2018 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

import UIKit
import LDOLayoutTemplates

class DashboardViewController: UIViewController {
    @IBOutlet weak var portraitLargeListLayout: LDOLayoutTemplate!
    @IBOutlet weak var landscapeLargeListLayout: LDOLayoutTemplate!
    private var defaultLayout: LDOLayoutTemplate!
    private var largeListLayoutActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLayout = LDOLayoutTemplate(forCurrentStateBasedOn: portraitLargeListLayout)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // default layout isn't specialized for either orientation, so we don't need to bother
        guard largeListLayoutActive else { return }
        
        // the large list layouts are different between landscape and portrait
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                self.landscapeLargeListLayout.apply()
            } else {
                self.portraitLargeListLayout.apply()
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func toggleLargeListLayout() {
        self.largeListLayoutActive.toggle()
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            if self.largeListLayoutActive {
                if self.view.bounds.width > self.view.bounds.height {
                    self.landscapeLargeListLayout.apply()
                } else {
                    self.portraitLargeListLayout.apply()
                }
            } else {
                self.defaultLayout.apply()
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension DashboardViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}
