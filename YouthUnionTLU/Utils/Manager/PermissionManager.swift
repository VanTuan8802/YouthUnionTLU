//
//  PermissionManager.swift
//  YouthUnionTLU
//
//  Created by Tuấn Nguyễn on 16/6/24.
//

import Foundation
import Photos
import AVFoundation
import UserNotifications
import UIKit

class PermissionManager {
    static let shared = PermissionManager()
    
    func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        return status == .authorized || status == .limited
    }
    
    func requestPhotoLibraryPermission(completionHandler: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            completionHandler(true)
        case .denied, .restricted:
            completionHandler(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        @unknown default:
            completionHandler(false)
        }
    }

    func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    func requestCameraPermission(completionHandler: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completionHandler(true)
        case .denied, .restricted:
            completionHandler(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        @unknown default:
            completionHandler(false)
        }
    }

    func checkNotificationPermission() -> Bool {
        let current = UNUserNotificationCenter.current()
        var isAuthorized = false
        
        let semaphore = DispatchSemaphore(value: 0)
        
        current.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                isAuthorized = true
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return isAuthorized
    }
    
    func requestNotificationPermission(completionHandler: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
                completionHandler(false)
                return
            }

            if granted {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func openSettingPermission() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }

    }
}
