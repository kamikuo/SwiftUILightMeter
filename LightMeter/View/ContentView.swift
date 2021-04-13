//
//  ContentView.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/9.
//

import SwiftUI

struct ContentView: View {
    @StateObject var lightMeter = LightMeter()
    
    private func CornerBorderPath(rect: CGRect) -> Path {
        let lineLength: CGFloat = 20
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + lineLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + lineLength, y: rect.minY))
        
        path.move(to: CGPoint(x: rect.maxX - lineLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + lineLength))
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - lineLength))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - lineLength, y: rect.maxY))
        
        path.move(to: CGPoint(x: rect.minX + lineLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - lineLength))
        
        return Path(path.cgPath)
    }
    
    var body: some View {
        VStack {
            
            GeometryReader { geometry in
                CameraPreview(session: lightMeter.camera.session)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .onAppear {
                        lightMeter.camera.configure()
                    }
                    .overlay(
                        CornerBorderPath(rect: CGRect(x: 0.5, y: 0.5, width: geometry.size.width - 1, height: geometry.size.height - 1))
                            .stroke(Color(white: 1.0, opacity: 0.6) ,style: StrokeStyle(lineWidth: 1))
                    )
            }
            
            VStack {
                LightMeterPanel(lightMeter: lightMeter)
            }
            .frame(height:200)
        }
        .background(Color("Background").edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
