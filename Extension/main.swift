//
//  main.swift
//  Extension
//
//  Created by David Crawford on 12/3/22.
//

import Foundation
import CoreMediaIO

let providerSource = ExtensionProviderSource(clientQueue: nil)
CMIOExtensionProvider.startService(provider: providerSource.provider)

CFRunLoopRun()
