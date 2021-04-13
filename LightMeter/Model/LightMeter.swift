//
//  LightMeter.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/11.
//

import Foundation
import AVFoundation


class LightMeter: ObservableObject {
    
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
    
    @Published var aperture: Float = 1.0 { didSet { update() } }
    @Published var apertureLock = false { didSet { update() } }
    @Published var speed: Float = 1.0 { didSet { update() } }
    @Published var speedLock = false { didSet { update() } }
    @Published var iso: Float = 100 { didSet { update() } }
    @Published var isoLock = false { didSet { update() } }
    
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
        
        if isoLock && speedLock && apertureLock {
            //preview mode
            let lockEV = ExposureValue(aperture: aperture, speed: speed, iso: iso)
            let iso = lockEV.iso(withAperture: camera.aperture, speed: speed)
            camera.setCustomExposure(speed: speed, iso: iso)
        } else {
            camera.clearCustomExposure()
            
            if isoLock {
                if speedLock {
                    //s mode
                    aperture = exposureStops.aperture(from: exposureValue.aperture(withSpeed: speed, iso: iso))
                } else if apertureLock {
                    //a mode
                    speed = exposureStops.speed(from: exposureValue.speed(withAperture: aperture, iso: iso))
                } else {
                    //p mode
                    aperture = exposureStops.aperture(from: camera.aperture)
                    speed = exposureStops.speed(from: exposureValue.speed(withAperture: aperture, iso: iso))
                }
            } else if speedLock {
                if !apertureLock {
                    //s mode & iso auto
                    aperture = exposureStops.aperture(from: camera.aperture)
                }
                //iso auto
                iso = exposureStops.iso(from: exposureValue.iso(withAperture: aperture, speed: speed))
            } else if apertureLock {
                //a mode & iso auto
                speed = exposureStops.speed(from: camera.speed)
                iso = exposureStops.iso(from: exposureValue.iso(withAperture: aperture, speed: speed))
            } else {
                //all auto
                aperture = exposureStops.aperture(from: camera.aperture)
                speed = exposureStops.speed(from: camera.speed)
                iso = exposureStops.iso(from: exposureValue.iso(withAperture: aperture, speed: speed))
            }
        }
        
        exposureOffset = ExposureValue(aperture: aperture, speed: speed, iso: iso).rawValue - exposureValue.rawValue
        
        updating = false
    }
}
