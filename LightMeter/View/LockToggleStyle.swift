//
//  LockToggleStyle.swift
//  LightMeter
//
//  Created by kamikuo on 2021/4/12.
//

import SwiftUI
//.stroke(Color.white.opacity(0.4), lineWidth: 0.5)
struct LockToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Rectangle()
                .foregroundColor(configuration.isOn ? Color(red: 0.92, green: 0.75, blue: 0) : Color.black)
                .frame(width: 33, height: 21, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .shadow(color: Color(white: 0, opacity: 0.15), radius: 1.5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        .padding(.all, 2)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 11, height: 11, alignment: .center)
                                .foregroundColor(configuration.isOn ? Color(red: 0.92, green: 0.75, blue: 0) : Color(white: 0.7))
                        )
                        .offset(x: configuration.isOn ? 6 : -6, y: 0)
                )
                .cornerRadius(10)
                
        }
        .frame(width: 63, height: 37, alignment: .center)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                configuration.isOn.toggle()
            }
        }
    }
}

struct LockToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Toggle(isOn: .constant(true), label: {
                Text("On")
            })
            .toggleStyle(LockToggleStyle())
            
            Toggle(isOn: .constant(false), label: {
                Text("Off")
            })
            .toggleStyle(LockToggleStyle())
            
        }
        .padding(.all, 100)
    }
}
