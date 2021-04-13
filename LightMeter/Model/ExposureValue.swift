//
//  ExposureValue.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/11.
//

import Foundation

struct ExposureValue: RawRepresentable {
    let rawValue: Float
    
    init(rawValue: Float) {
        self.rawValue = rawValue
    }
    
    init(aperture: Float, speed: Float, iso: Float) {
        self.rawValue = log2(pow(aperture, 2) / speed) - log2(iso / 100)
    }
    
    func aperture(withSpeed speed: Float, iso: Float) -> Float {
        return sqrtf(pow(2, rawValue + log2(iso / 100)) * speed)
    }
    
    func speed(withAperture aperture: Float, iso: Float) -> Float {
        return pow(aperture, 2) / pow(2, rawValue + log2(iso / 100))
    }
    
    func iso(withAperture aperture: Float, speed: Float) -> Float {
        return pow(2, log2(pow(aperture, 2) / speed) - rawValue) * 100
    }
}
