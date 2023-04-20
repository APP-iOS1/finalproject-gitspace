//
//  HalfSheetManager.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/04/20.
//

import SwiftUI
import UIKit

struct HalfSheetManager<SheetView: View>: UIViewControllerRepresentable {
    @Binding var showSheet: Bool
    var sheetView: SheetView
    var onEnd: () -> ()
    let controller = UIViewController()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            // choosing view when showsheet toggled againg
            uiViewController.dismiss(animated: true)
        }
    }
    
    // On dismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetManager

        init(parent: HalfSheetManager) {
            self.parent = parent
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}
