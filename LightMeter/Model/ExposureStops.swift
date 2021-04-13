//
//  ExposureStops.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/11.
//

import Foundation

struct ExposureStops {
    enum Stops {
        case full
        case halves
        case thirds
    }
    
    let apertureStops: [Float]
    let speedStops: [Float]
    let isoStops: [Float]
    
    init(stops: Stops) {
        
        // [0, 1/3, 1/2, 2/3, ...]
        
        let apertureList: [Float] = [
            1.0, 1.1, 1.2, 1.3,
            1.4, 1.6, 1.7, 1.8,
            2.0, 2.2, 2.4, 2.5,
            2.8, 3.2, 3.5, 3.5,
            4.0, 4.5, 4.5, 5.0,
            5.6, 6.3, 6.7, 7.1,
            8.0, 9.0, 9.5, 10,
            11, 13, 13, 14,
            16, 18, 19, 20,
            22, 25, 27, 28,
            32, 36, 38, 40,
            45, 51, 54, 57,
            64, 72, 76, 81,
            90, 100, 107, 115,
            128]
        
        let speedList: [Float] = [
            30, 25, 20, 20,
            15, 13, 10, 10,
            8, 6, 6, 5,
            4, 3.2, 3, 2.5,
            2, 1.6, 1.5, 1.3,
            1, 0.8, 0.7, 0.6,
            0.5, 0.4, 1/3, 1/3,
            1/4, 1/5, 1/6, 1/6,
            1/8, 1/10, 1/10, 1/13,
            1/15, 1/20, 1/20, 1/25,
            1/30, 1/40, 1/45, 1/50,
            1/60, 1/80, 1/90, 1/100,
            1/125, 1/160, 1/200, 1/200,
            1/250, 1/320, 1/350, 1/400,
            1/500, 1/640, 1/750, 1/800,
            1/1000, 1/1250, 1/1500, 1/1600,
            1/2000, 1/2500, 1/3000, 1/3200,
            1/4000, 1/5000, 1/6000, 1/6400,
            1/8000]
        
        let isoList: [Float] = [
            6, 8, 9, 10,
            12, 16, 18, 20,
            25, 32, 35, 40,
            50, 64, 70, 80,
            100, 125, 140, 160,
            200, 250, 280, 320,
            400, 500, 560, 640,
            800, 1000, 1100, 1250,
            1600, 2000, 2200, 2500,
            3200, 4000, 4400, 5000,
            6400, 8000, 8800, 10000,
            12800, 16000, 17600, 20000,
            25600, 32000, 35200, 40000,
            51200, 64000, 70400, 80000,
            102400]
        
        if stops == .full {
            apertureStops = stride(from: 0, to: apertureList.count, by: 4).map{ apertureList[$0] }
            speedStops = stride(from: 0, to: speedList.count, by: 4).map{ speedList[$0] }
            isoStops = [1, 3] + stride(from: 0, to: isoList.count, by: 4).map({ isoList[$0] })
        } else if stops == .halves {
            apertureStops = stride(from: 0, to: apertureList.count, by: 2).map{ apertureList[$0] }
            speedStops = stride(from: 0, to: speedList.count, by: 2).map{ speedList[$0] }
            isoStops = [1, 3] + stride(from: 0, to: isoList.count, by: 2).map({ isoList[$0] })
        } else {
            apertureStops = apertureList.enumerated().filter({ $0.offset % 4 != 2 }).map({ $0.element })
            speedStops = speedList.enumerated().filter({ $0.offset % 4 != 2 }).map({ $0.element })
            isoStops = [1, 3] + isoList.enumerated().filter({ $0.offset % 4 != 2 }).map({ $0.element })
        }
    }
    
    private func getClosedValue(with value: Float, in array: [Float]) -> Float {
        var diff = Float.greatestFiniteMagnitude
        var result: Float = 0
        for val in array {
            let nowDiff = fabsf(val - value)
            if nowDiff > diff {
                break
            }
            diff = nowDiff
            result = val
        }
        return result
    }
    
    func aperture(from aperture: Float) -> Float {
        return getClosedValue(with: aperture, in: apertureStops)
    }
    
    func speed(from speed: Float) -> Float {
        return getClosedValue(with: speed, in: speedStops)
    }
    
    func iso(from iso: Float) -> Float {
        return getClosedValue(with: iso, in: isoStops)
    }
}
