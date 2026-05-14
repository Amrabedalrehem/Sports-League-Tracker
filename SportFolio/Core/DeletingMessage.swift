import UIKit

final class AlertManager {

    static func showDeleteConfirmation(
        on viewController: UIViewController,
        title: String = L10n.alertRemoveFavoriteTitle,
        message: String = L10n.alertRemoveFavoriteMessage,
        deleteTitle: String = L10n.alertDelete,
        cancelTitle: String = L10n.alertCancel,
        onDelete: @escaping () -> Void
    ) {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(
            title: deleteTitle,
            style: .destructive
        ) { _ in
            onDelete()
        }

        let cancelAction = UIAlertAction(
            title: cancelTitle,
            style: .cancel
        )

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        viewController.present(alert, animated: true)
    }
}
