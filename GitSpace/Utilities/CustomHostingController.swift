//
//  CustomHostingController.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/04/20.
//

import SwiftUI

class CustomHostingController<Content: View>: UIHostingController<Content> {

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        print(rootView)
        // setting presentation controller properties
        if let presentationController = presentationController as? UISheetPresentationController {
            
            switch rootView {
            case is ReportView:
                presentationController.detents = [
                    .large()
                ]
            default:
                presentationController.detents = [
                    .medium(),
                    .large()
                ]
            }
            // to show grab protion
            presentationController.prefersGrabberVisible = true
        }
    }
}
