//
//  TargetView.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 25/05/23.
//

import SwiftUI

struct TargetView: View {
    @ObservedObject  var userViewModel: UserViewModel

    @State private var searchText = ""
    private var data: [String] = ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", ]

    
    var datas: [String] {
        let a = data.map{$0.lowercased()}
        return searchText == "" ? a : a.filter{
            $0.contains(searchText.lowercased())
        }
    }
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    
    @State var listTarget: [UserModel] = []
        
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .center){
                    if(userViewModel.userTarget != nil  ){
                        var _ = print("ekek", userViewModel.userTarget)
                        Text("\(userViewModel.userTarget?.firstName ?? "") \(userViewModel.userTarget?.lastName ?? "")")
                            .foregroundColor(.white).foregroundColor(.white)
                            .font(Font.system(size: 16, design: .rounded).weight(.semibold))
                        Spacer().frame(height: 4)
                        Text(verbatim: userViewModel.userTarget?.email ?? "")
                            .foregroundColor(.white.opacity(0.8))
                            .font(Font.system(size: 12, design: .rounded))
                    } else {
                        Text(verbatim:"Select your target in the list below")
                            .foregroundColor(.white.opacity(0.8))
                            .font(Font.system(size: 12, design: .rounded))
                    }
                }
                .padding(16)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("pink2"), Color("pink1")]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(16)
                .padding(24)
                List{
                    
                    if(userViewModel.viewState == ViewState.loaded){
                        ForEach(0..<listTarget.count, id: \.self){ index in
                            VStack{
                                Text("\(listTarget[index].firstName ?? "") \(listTarget[index].lastName ?? "")")
                                    .font(Font.system(size: 16, design: .rounded).weight(.semibold))
                                Spacer().frame(height: 4)
                                Text("\(listTarget[index].email ?? "")")
                                
                                    .font(Font.system(size: 12, design: .rounded).weight(.regular))
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(16)
                            .onTapGesture {
                                Task{
                                    
                                    userViewModel.viewState = ViewState.loading
                                    let email = listTarget[index].email!
                                    await userViewModel.updateUserLovedBy(email) // update target loved by
                                    await userViewModel.updateUserTarget(email) // update this user target
                                    
                                    let newUserModel = await userViewModel.getUserFromCloudKit()
                                    if (newUserModel != nil){
                                        userViewModel.userModel = newUserModel
                                    }
                                    let newUserTarget = await userViewModel.getUserByEmail(userViewModel.userModel?.target ?? "")
                                    print("executed")
                                    if(newUserTarget != nil){
                                        print("executed")
                                        userViewModel.userTarget = newUserTarget
                                    }
                                    
                                    userViewModel.viewState = ViewState.loaded
                                    
                                }
                            }
                        }
                    } else {
                        Text("Loading")
                    }
                }.onAppear{
                    Task{
                        userViewModel.viewState = ViewState.loading
                        listTarget = await userViewModel.getAllUser()
                        print(listTarget)
                        userViewModel.viewState = ViewState.loaded
                    }
                }
            }
//            .searchable(text: $searchText)
                
        }
        .navigationTitle("Select Target")
        
    }
}

//struct TargetView_Previews: PreviewProvider {
//    static var previews: some View {
//        TargetView()
//    }
//}
