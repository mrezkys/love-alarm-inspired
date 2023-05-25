//
//  ProfileView.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 24/05/23.
//

import SwiftUI
import AuthenticationServices


struct ProfileView: View {
    @State var fullName: String = ""
    @State var email: String = ""
    @ObservedObject var userViewModel: UserViewModel
    

    func configure(_ request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.email, .fullName]
        
    }
    
    func handle(_ authResult: Result<ASAuthorization, Error>) async {
        switch authResult {
        case .success(let auth):
            print(auth)
            switch auth.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let userModel = UserModel(credentials: appleIdCredentials) {
                    await userViewModel.register(userModel)
                } else {
                    print("Failed to create UserModel from credentials.")
                }
            default:
                print(auth.credential)
            }
        case .failure(let error):
            print(error)
        }
    }
    
    var body: some View{
        NavigationView{
            VStack(alignment: .center, spacing: 16){
                if(userViewModel.userModel != nil){
                    VStack{
                        VStack(alignment: .leading){
                            Text("Full Name")
                                .font(Font.system(size: 12, design: .rounded).weight(.regular))
                            TextField("Jhon Doe", text: $fullName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        VStack(alignment: .leading){
                            Text("Email")
                                .font(Font.system(size: 12, design: .rounded).weight(.regular))
                            TextField("Input your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(true)
                        }
                        Spacer()
                        Button{} label: {
                            Text("Sign Out")                    .foregroundColor(.white)
                            
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background( LinearGradient(gradient: Gradient(colors: [Color("pink2"), Color("pink1")]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(16)
                            
                            
                        }
                    }.onAppear{
                        email = "\(userViewModel.userModel!.email!)"
                        fullName = "\(userViewModel.userModel!.firstName!) \(userViewModel.userModel!.lastName!)"
                    }
                }
                else {
                    Spacer()
                    Text("You need to sign in to use this feature")
                    Spacer()
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: configure,
                        onCompletion: { result in
                            Task.detached {
                                await handle(result)
                            }
                        }
                    ).frame(height: 60)
                }
                
            }
            .padding(24)
        }.navigationTitle("Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    if(userViewModel.userModel != nil){
                        Button("Save") {}
                    } else {
                        EmptyView()
                    }
                }
            }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
