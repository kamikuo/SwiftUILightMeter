//
//  LightMeterPanel.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/11.
//

import SwiftUI

struct LightMeterPanel: View {
    @StateObject var lightMeter: LightMeter
    
    private func speedToString(_ speed: Float) -> String {
        if speed >= 1.0 {
            return String(Int(speed)) + "\""
        }
        return "1/" + String(Int(round(1 / speed)))
    }
    
    private func apertureToString(_ aperture: Float) -> String {
        return String(format: "F%.1f", aperture)
    }
    
    private func CornerRadiusPath() -> Path {
        var path = Rectangle().path(in: CGRect(x: 0, y: 0, width: 80, height: 32))
        let hole = RoundedRectangle(cornerRadius: 6).path(in: CGRect(x: 0, y: 0, width: 80, height: 32))
        let reversedCGPath = UIBezierPath(cgPath: hole.cgPath).reversing().cgPath
        path.addPath(Path(reversedCGPath))
        return path
    }
    
    var body: some View {
        VStack {
            //ev bar
            
            ZStack {
                HStack {
                    Spacer()
                    
                    Picker(selection: Binding(get: {
                        lightMeter.exposureSetting.speed
                    }, set: { val in
                        lightMeter.exposureSetting.speedLock = true
                        lightMeter.exposureSetting.speed = val
                    }), label: Text("ISO"), content: {
                        ForEach(lightMeter.exposureStops.speedStops, id: \.self) { speed in
                            Text(speedToString(speed))
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    })
                    .animation(.easeInOut)
                    .labelsHidden()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .overlay(
                        Rectangle()
                            .frame(width: 80, height: 32, alignment: .center)
                            .foregroundColor(Color("Background"))
                            .clipShape(CornerRadiusPath())
                    )
                    
                    Spacer()

                    Picker(selection: Binding(get: {
                        lightMeter.exposureSetting.aperture
                    }, set: { val in
                        lightMeter.exposureSetting.apertureLock = true
                        lightMeter.exposureSetting.aperture = val
                    }), label: Text("ISO"), content: {
                        ForEach(lightMeter.exposureStops.apertureStops, id: \.self) { aperture in
                            Text(apertureToString(aperture))
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    })
                    .animation(.easeInOut)
                    .labelsHidden()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .overlay(
                        Rectangle()
                            .frame(width: 80, height: 32, alignment: .center)
                            .foregroundColor(Color("Background"))
                            .clipShape(CornerRadiusPath())
                    )

                    Spacer()

                    Picker(selection: Binding(get: {
                        lightMeter.exposureSetting.iso
                    }, set: { val in
                        lightMeter.exposureSetting.isoLock = true
                        lightMeter.exposureSetting.iso = val
                    }), label: Text("ISO"), content: {
                        ForEach(lightMeter.exposureStops.isoStops, id: \.self) { iso in
                            Text(String(Int(iso)))
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    })
                    .animation(.easeInOut)
                    .labelsHidden()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .overlay(
                        Rectangle()
                            .frame(width: 80, height: 32, alignment: .center)
                            .foregroundColor(Color("Background"))
                            .clipShape(CornerRadiusPath())
                    )
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("SPEED")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                        
                        Toggle("", isOn: $lightMeter.exposureSetting.speedLock)
                            .toggleStyle(LockToggleStyle())
                            .padding(.top, 2.0)
                        
                        Spacer()
                    }
                    .frame(maxWidth: 80)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("APERTURE")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                        
                        Toggle("", isOn: $lightMeter.exposureSetting.apertureLock)
                            .toggleStyle(LockToggleStyle())
                            .padding(.top, 2.0)
                        
                        Spacer()
                    }
                    .frame(maxWidth: 80)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("ISO")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                        
                        Toggle("", isOn: $lightMeter.exposureSetting.isoLock)
                            .toggleStyle(LockToggleStyle())
                            .padding(.top, 2.0)
                        
                        Spacer()
                    }
                    .frame(maxWidth: 80)
                    
                    Spacer()
                }
                .padding(.top, 16)
            }.frame(height: 180)
        }
    }
}

struct LightMeterPanel_Previews: PreviewProvider {
    static var previews: some View {
        LightMeterPanel(lightMeter: LightMeter())
            .background(Color("Background"))
    }
}
