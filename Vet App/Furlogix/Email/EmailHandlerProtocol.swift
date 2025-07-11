//
//  EmailHandlerProtocol.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import UIKit
import MessageUI

protocol EmailHandlerProtocol {
    func createAndSendEmail(wrapper: EmailWrapper, presentingController: UIViewController)
    func createAndSendEmailWithMF(wrapper: EmailWrapper, presentingController: UIViewController)
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?)
}
