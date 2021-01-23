//
//  ContentView.swift
//  SwiftHarjoitus
//
//  Created by Student on 23/01/2021.
//  Copyright © 2021 Rankinen Jarno TVT19KMO. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var elapsedSeconds = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        
        HStack {
            
            Text("\(elapsedSeconds)")
                .onReceive(timer) {_ in
                    self.elapsedSeconds += 1
                }
            
            
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
