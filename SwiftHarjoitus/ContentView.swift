//
//  ContentView.swift
//  SwiftHarjoitus
//
//  Created by Jarno Rankinen on 23/01/2021.
//  Copyright © 2021 Rankinen Jarno TVT19KMO. All rights reserved.
//

import SwiftUI

func makeTime(seconds: Int) -> String {
    // makeTime converts seconds (Integer) to hours, minutes and seconds
    // returns a String, e.g. "1h 13min 3s"
    let minutes: Int = (seconds - seconds % 60) / 60
    let hours: Int = (minutes - minutes % 60) / 60
    let seconds = seconds % 60
    let printMinutes = minutes % 60
    return "\(hours)h \(printMinutes)min \(seconds)s"
}

struct ContentView: View {
    
    // UserDefaults are used to store the running state, start time and the
    // length of the previous workday
    let state = UserDefaults.standard
    
    @State var elapsedString = "Workday not started" // String for the current status
    
    @State var startTime = Date()   // The start time of the workday
    @State var elapsedTime = 0      // duration of the current workday in seconds
    
    @State var running = false      // Workday started or not
    
    // Timer is used to update the variables and
    // content on the screen, not for the actual timekeeping
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func loadPrevious() {
        // Check if the timer was running last time the application was closed,
        // and update startTime and running accordingly.
        // Duration of the previous workday is loaded from UserDefaults either way.
        if self.state.bool(forKey: "was_running") == true {
            self.running = self.state.bool(forKey: "was_running")
            self.startTime = self.state.object(forKey: "start_time") as! Date
        }
        else {
            self.startTime = Date()
        }
        self.elapsedTime = self.state.integer(forKey: "last_elapsed")
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("\(elapsedString)")
                .onReceive(timer) {_ in
                    // A signal is received every second, and the screen is
                    // updated when the signal is received
                    
                    self.loadPrevious() // load the previous status from UserDefaults
                    
                    // If the workday has been started:
                    if self.running {
                        // Calculate the interval between now and startTime,
                        // round up and convert from the resulting double to Integer:
                        self.elapsedTime = Int(ceil(Date().timeIntervalSince(self.startTime)))
                        // Save the duration for showing the duration of previous workday:
                        self.state.set(self.elapsedTime, forKey: "last_elapsed")
                        // Update the time shown on screen:
                        self.elapsedString = "Workday so far:\n"
                            + makeTime(seconds: self.elapsedTime)
                    }
                    // If the workday has not been started:
                    else {
                        // Save the start time to UserDefaults:
                        self.state.set(self.startTime, forKey: "start_time")
                        // Show the previous workday duration:
                        self.elapsedString = "Workday not started.\nPrevious workday: "
                            + makeTime(seconds: self.elapsedTime)
                    }
                    
                }
            
            Spacer()
            
            Button( action:
            {
                // On button press
                // If the workday is not started:
                if !self.running {
                    self.startTime = Date()                     // Store the start time
                    self.running = true                         // set running state
                    self.state.set(true, forKey: "was_running") // store running state
                    self.elapsedTime = 0                        // reset elapsedTime
                }
                // If the workday is started:
                else {
                    self.running = false                        // set the running state
                    self.state.set(false, forKey: "was_running")// and store it
                }
                print("\(self.startTime)\n\(self.elapsedTime)") // debugging
            } )
            {
                // Set the button text according to running state
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
