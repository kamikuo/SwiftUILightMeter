//
//  LightMeter.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/11.
//

import Foundation
import AVFoundation


class LightMeter: ObservableObject {
    
    struct ExposureSetting {
        var aperture: Float = 1.0
        var apertureLock = false
        
        var speed: Float = 1.0
        var speedLock = false
        
        var iso: Float = 100
        var isoLock = false
    }
    
    let camera = Camera()
    
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(callback))
        displayLink.preferredFramesPerSecond = 6
        return displayLink
    }()
    
    init() {
        displayLink.add(to: .main, forMode: .common)
    }
    
    @Published var exposureStops = ExposureStops(stops: .full)
    
    @Published var exposureSetting = ExposureSetting() {
        didSet { update() }
    }
    
    @Published private(set) var exposureOffset: Float = 0
    
    private(set) var exposureValue = ExposureValue(rawValue: 0) {
        didSet {
            if oldValue != exposureValue {
                update()
            }
        }
    }
    
    @objc private func callback(displayLink: CADisplayLink){
        exposureValue = ExposureValue(aperture: camera.aperture, speed: camera.speed, iso: camera.iso)
    }
    
    private var updating = false
    private func update() {
        guard !updating else { return }
        updating = true
        
        var es = self.exposureSetting
        
        if es.isoLock && es.speedLock && es.apertureLock {
            //preview mode
            let lockEV = ExposureValue(aperture: es.aperture, speed: es.speed, iso: es.iso)
            let iso = lockEV.iso(withAperture: camera.aperture, speed: es.speed)
            camera.setCustomExposure(speed: es.speed, iso: iso)
        } else {
            //
            camera.clearCustomExposure()
            
            if es.isoLock {
                if es.speedLock {
                    //s mode
                    es.aperture = exposureStops.aperture(from: exposureValue.aperture(withSpeed: es.speed, iso: es.iso))
                } else if es.apertureLock {
                    //a mode
                    es.speed = exposureStops.speed(from: exposureValue.speed(withAperture: es.aperture, iso: es.iso))
                } else {
                    //p mode
                    es.aperture = exposureStops.aperture(from: camera.aperture)
                    es.speed = exposureStops.speed(from: exposureValue.speed(withAperture: es.aperture, iso: es.iso))
                }
            } else if es.speedLock {
                if !es.apertureLock {
                    //s mode & iso auto
                    es.aperture = exposureStops.aperture(from: camera.aperture)
                }
                //iso auto
                es.iso = exposureStops.iso(from: exposureValue.iso(withAperture: es.aperture, speed: es.speed))
            } else if es.apertureLock {
                //a mode & iso auto
                es.speed = exposureStops.speed(from: camera.speed)
                es.iso = exposureStops.iso(from: exposureValue.iso(withAperture: es.aperture, speed: es.speed))
            } else {
                //all auto
                es.aperture = exposureStops.aperture(from: camera.aperture)
                es.speed = exposureStops.speed(from: camera.speed)
                es.iso = exposureStops.iso(from: exposureValue.iso(withAperture: es.aperture, speed: es.speed))
            }
            
            exposureSetting = es
        }
        
        exposureOffset = ExposureValue(aperture: es.aperture, speed: es.speed, iso: es.iso).rawValue - exposureValue.rawValue
        
//        print(exposureValue, exposureOffset, camera.exposureValue, camera.speed, camera.aperture, camera.iso)
        
        updating = false
    }
}
