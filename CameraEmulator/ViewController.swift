//
//  ViewController.swift
//  CameraEmulator
//
//  Created by David Crawford on 12/3/22.
//

import Cocoa
import SystemExtensions

class ViewController: NSViewController {
    
    @IBOutlet var logText: NSTextField!
    
    @IBAction func install(_ sender: Any) {
        
        guard let extensionIdentifier = ViewController._extensionBundle().bundleIdentifier else {
            return
        }
        
        // Activate the system extension
        let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }
    
    @IBAction func uninstall(_ sender: Any) {
        guard let extensionIdentifier = ViewController._extensionBundle().bundleIdentifier else {
            return
        }
        
        // Deactivate the system extension
        let deactivationRequest = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
        deactivationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(deactivationRequest)
    }

    private class func _extensionBundle() -> Bundle {
        
        let extensionsDirectoryURL = URL(fileURLWithPath: "Contents/Library/SystemExtensions", relativeTo: Bundle.main.bundleURL)
        let extensionURLs: [URL]
        do {
            extensionURLs = try FileManager.default.contentsOfDirectory(at: extensionsDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch let error {
            fatalError("Failed to get the contents of \(extensionsDirectoryURL.absoluteString): \(error.localizedDescription)")
        }
        
        guard let extensionURL = extensionURLs.first else {
            fatalError("Failed to find any system extensions")
        }
        
        guard let extensionBundle = Bundle(url: extensionURL) else {
            fatalError("Failed to create a bundle with URL \(extensionURL.absoluteString)")
        }
        return extensionBundle
            
    }
}

extension ViewController: OSSystemExtensionRequestDelegate {
    
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        
        logText.stringValue = "Replacing extension version \(existing.bundleShortVersion) with \(ext.bundleShortVersion)"
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        logText.stringValue = "Extension needs user approval"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        logText.stringValue = "Request finished with result: \(result.rawValue)"
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        logText.stringValue = "request failed: \(error)"
    }
}

