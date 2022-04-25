//
//	Extensions
//  Travel Travnik AR
//	Created by: @nedimf on 12/11/2021


import Foundation
import UIKit
import SwiftUI
import Photos
import VideoToolbox

extension UIViewController {

    /// Add a SwiftUI `View` as a child of the input `UIView`.
    /// - Parameters:
    ///   - swiftUIView: The SwiftUI `View` to add as a child.
    ///   - view: The `UIView` instance to which the view should be added.
    func addSubSwiftUIView<Content>(_ swiftUIView: Content, to view: UIView) where Content : View {
        let hostingController = UIHostingController(rootView: swiftUIView)

        /// Add as a child of the current view controller.
        addChild(hostingController)

        /// Add the SwiftUI view to the view controller view hierarchy.
        view.addSubview(hostingController.view)

        /// Setup the contraints to update the SwiftUI view boundaries.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        /// Notify the hosting controller that it has been moved to the current view controller.
        hostingController.didMove(toParent: self)
    }
    
    
}

extension View {
    func snapshot(targetSize: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        //view?.transform = CGAffineTransform(scaleX: 5.1, y: 5.1)

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIColor{
    struct Custom {
        static var black: UIColor{
            if #available(iOS 13, *) {
                return UIColor.init { (trait) -> UIColor in
                    return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
                }
            }
            return UIColor.black
        }
    }
    
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

