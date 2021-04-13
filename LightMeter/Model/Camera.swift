//
//  Camera.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/9.
//

import Foundation
import AVFoundation

class Camera {
    enum ConfigureError: Swift.Error {
        case deviceNotFound
        case addInputFail
        case addOutputFail
        case unknown
    }
 
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    private var cameraDevice: AVCaptureDevice?
    private var cameraDeviceInput: AVCaptureDeviceInput?
//    private let photoOutput = AVCapturePhotoOutput()
    
    func configure() {
        sessionQueue.async {
            try? self.configureSession()
        }
    }
    
    private func configureSession() throws {
        
        session.sessionPreset = .photo
        
        guard let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw ConfigureError.deviceNotFound
        }
        self.cameraDevice = cameraDevice
        
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: cameraDevice)
            guard session.canAddInput(videoDeviceInput) else {
                throw ConfigureError.addInputFail
            }
            session.addInput(videoDeviceInput)
            self.cameraDeviceInput = videoDeviceInput
        } catch {
            throw ConfigureError.addInputFail
        }
        
//        guard session.canAddOutput(photoOutput) else {
//            throw ConfigureError.addOutputFail
//        }
//        session.addOutput(photoOutput)
        
        session.startRunning()
        
        //disable HDR
        do {
            try cameraDevice.lockForConfiguration()
            cameraDevice.automaticallyAdjustsVideoHDREnabled = false
            cameraDevice.isVideoHDREnabled = false
            cameraDevice.unlockForConfiguration()
        } catch {

        }
    }
    
    var aperture: Float {
        return cameraDevice?.lensAperture ?? 1.0
    }
    
    var iso: Float {
        return cameraDevice?.iso ?? 100
    }
    
    var speed: Float {
        if let time = cameraDevice?.exposureDuration {
            return Float(CMTimeGetSeconds(time))
        }
        return 1.0
    }
    
    func setCustomExposure(speed: Float, iso: Float) {
        guard let cameraDevice = cameraDevice else { return }
        
        let ev = ExposureValue(aperture: aperture, speed: speed, iso: iso)
        
        var safeSpeed = min(max(speed, Float(CMTimeGetSeconds(cameraDevice.activeFormat.minExposureDuration))), 1/15.0)
        var safeISO = ev.iso(withAperture: aperture, speed: safeSpeed)
        if safeISO < cameraDevice.activeFormat.minISO || safeISO > cameraDevice.activeFormat.maxISO {
            safeISO = min(max(safeISO, cameraDevice.activeFormat.minISO), cameraDevice.activeFormat.maxISO)
            safeSpeed = min(max(ev.speed(withAperture: aperture, iso: safeISO), Float(CMTimeGetSeconds(cameraDevice.activeFormat.minExposureDuration))), Float(CMTimeGetSeconds(cameraDevice.activeFormat.maxExposureDuration)))
        }
        
        do {
            try cameraDevice.lockForConfiguration()
            cameraDevice.exposureMode = .custom
            cameraDevice.setExposureModeCustom(duration: CMTimeMakeWithSeconds(Double(safeSpeed), preferredTimescale: 1000000000), iso: safeISO, completionHandler: nil)
            cameraDevice.unlockForConfiguration()
        } catch {
        }
    }
    
    func clearCustomExposure() {
        guard let cameraDevice = cameraDevice, cameraDevice.exposureMode != .continuousAutoExposure else { return }
        do {
            try cameraDevice.lockForConfiguration()
            cameraDevice.exposureMode = .continuousAutoExposure
            cameraDevice.unlockForConfiguration()
        } catch {
        }
    }
}
