//
//  ErrorHandler.swift
//  MovieExplorer
//
//  Created by Ekbana on 20/11/2025.
//

import UIKit

class ErrorHandler {
    static let shared = ErrorHandler()
    private init() {}
    
    func handleError(_ error: Error?, in viewController: UIViewController, retryAction: (() -> Void)? = nil) {
        guard let error = error else { return }
        
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        if let networkError = error as? NetworkError, networkError.canRetry {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                retryAction?()
            })
            
            if case .noInternetConnection = networkError {
                alert.addAction(UIAlertAction(title: "Use Offline Mode", style: .default) { _ in
                    NotificationCenter.default.post(name: .useOfflineMode, object: nil)
                })
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController.present(alert, animated: true)
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let useOfflineMode = Notification.Name("useOfflineMode")
}

// MARK: - UIViewController Extension for Convenience
extension UIViewController {
    func showError(_ error: Error?, retryAction: (() -> Void)? = nil) {
        ErrorHandler.shared.handleError(error, in: self, retryAction: retryAction)
    }
}
