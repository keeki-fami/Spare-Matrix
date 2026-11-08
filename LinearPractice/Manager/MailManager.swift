//
//  MailManager.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/08
//  
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var recipients: [String]
    var subject: String
    var body: String
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        return vc
    }
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            // 送信完了・キャンセル時などにシートを閉じる
            parent.dismiss()
        }
    }
}
