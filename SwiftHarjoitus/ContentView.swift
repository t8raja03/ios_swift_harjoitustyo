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
    
    let state = UserDefaults.standard
    
    @State var elapsedSeconds = 0
    @State var elapsedString = "Workday not started"
    
    @State var startTime = Date()
    //@State var endTime = Date()
    @State var elapsedTime = 0
    
    @State var running = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func loadPrevious() {
        if self.state.bool(forKey: "was_running") == true {
            self.running = self.state.bool(forKey: "was_running")
            self.startTime = self.state.object(forKey: "start_time") as! Date
        }
        else {
            self.startTime = Date()
        }
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("\(elapsedString)")
                .onReceive(timer) {_ in
                    if self.running {
                        //self.endTime = input
                        //self.elapsedSeconds += 1
                        self.loadPrevious()
                        self.elapsedTime = Int(ceil(Date().timeIntervalSince(self.startTime)))
                        self.elapsedString = "Workday so far:\n" + makeTime(seconds: self.elapsedTime)
                    }
                    else {
                        self.loadPrevious()
                        self.state.set(self.startTime, forKey: "start_time")
                    }
                    
                }
            
            Spacer()
            
            Button( action:
            {
                if !self.running {
                    self.startTime = Date()
                    self.running = true
                    self.state.set(true, forKey: "was_running")
                    self.elapsedTime = 0
                }
                else {
                    self.running = false
                    self.state.set(false, forKey: "was_running")
                }
                print("\(self.startTime)\n\(self.elapsedTime)")
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
