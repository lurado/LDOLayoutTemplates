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
        defaultLayout = LDOLayoutTemplate(withCurrentStateForViewsIn: portraitLargeListLayout)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.applyLayout(for: size)
        })
    }
    
    @IBAction func toggleLargeListLayout() {
        largeListLayoutActive.toggle()
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.applyLayout(for: self.view.bounds.size)
        }
    }
    
    private func applyLayout(for size: CGSize) {
        if largeListLayoutActive {
            if size.width > size.height {
                landscapeLargeListLayout.apply()
            } else {
                portraitLargeListLayout.apply()
            }
        } else {
            defaultLayout.apply()
        }
        view.layoutIfNeeded()
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
