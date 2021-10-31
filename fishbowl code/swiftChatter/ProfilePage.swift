//
//  ProfilePage.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 10/28/21.
//

import SwiftUI

final class ProfilePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup refreshControler here later
    }
}

struct ContentView: View{
    var body: some View{
        Profile()
    }
}

struct ContentView_Previews:PreviewProvider{
    static var previews: some View {
        ContentView()
    }
}

struct Profile : View {
    
    var body : some View{
        
        ZStack{
            
            Image("profilepic").resizable().edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("menu").renderingMode(.original).resizable().frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        
                        Image("close").renderingMode(.original).resizable().frame(width: 20, height: 20)
                    }
                }
                
            }.padding()
            
        }
    }
    
}
