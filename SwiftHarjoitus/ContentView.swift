//
//  ContentView.swift
//  SwiftHarjoitus
//
//  Created by Jarno Rankinen on 23/01/2021.
//  Copyright © 2021 Rankinen Jarno TVT19KMO. All rights reserved.
//

import SwiftUI

func makeTime(seconds: Int) -> String {
    let minutes: Int = (seconds - seconds % 60) / 60
    let hours: Int = (minutes - minutes % 60) / 60
    let seconds = seconds % 60
    let printMinutes = minutes % 60
    return "\(hours)h \(printMinutes)min \(seconds)s"
}

struct ContentView: View {
    
    @State var elapsedSeconds = 0
    @State var elapsedString = "Workday not started"
    
    @State var running = false
    
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("\(elapsedString)")
                .onReceive(timer) {_ in
                    if self.running {
                        self.elapsedSeconds += 1
                        self.elapsedString = makeTime(seconds: self.elapsedSeconds)
                    }
                    
                }
            
            Spacer()
            
            Button( action:
            {
                self.running = !self.running
            } )
            {
                if !self.running {
                    Text( "Start workday" )
                }
                else {
                    Text( "End workday" )
                }
            }
            
            Spacer()
            
            
        }
    }
    
    /*
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("First View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
                    }
                }
                .tag(1)
        }
    }*/
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
