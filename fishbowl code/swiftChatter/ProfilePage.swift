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
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var bioView: UITextView!
    
    
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
                
                Spacer()
                
                VStack{
                    
                    HStack{
                        
                        Text("Hello").padding()
                        
                        Spacer()
                    }
                    
                    
                }
                 .frame(height: 250)
                .background(Color.white)
                .clipShape(BottomShape())
                
            }.padding()
            
        }
    }
    
}

struct BottomShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x:0, y:rect.height))
            path.addLine(to:CGPoint(x:rect.width, y: rect.height))
            path.addLine(to:CGPoint(x:rect.width, y:0))
            
        }
        
    }
    
}
