//
//  ContentView.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 23/05/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @ObservedObject var notificationManager = NotificationManager()
    
    @State private var isDiscoverable = false
    @State private var isNotifiable = false
    @State private var isScalingUp = false
    
    // routing
    @State private var routeToProfile = false
    @State private var routeToTarget = false
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation {
                isScalingUp = !isScalingUp // Toggle the scale state
            }
        }
    }
//
//    private func autoRefresh() {
//        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//            Task{
//              await  userViewModel.refresh()
//            }
//        }
//    }
//
    
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    
    var body: some View {
        
        NavigationView{
            GeometryReader{geometry in
                VStack {
                    Spacer()
                    ZStack{
                        Image("love")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.75)
                            .opacity(0.2)
                            .scaleEffect(isScalingUp ? 1.2 : 1.0) // Apply scale effect based on state
                            .animation(Animation.linear(duration: 1).repeatForever(), value: 1) // Animation with repeat
                        
                        Image("love")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.65)
                        VStack{
                            Text("\((userViewModel.userModel?.lovedBy.count ?? 1)-1)")
                                .font(Font.system(size: 64, design: .rounded).weight(.bold))
                                .foregroundColor(Color("pink1"))
                            Text("Person Love You")
                                .font(Font.system(size: 12, design: .rounded).weight(.semibold))
                                .foregroundColor(Color("pink1"))
                                .multilineTextAlignment(.center)
                            Text("tap to refresh")
                                .font(Font.system(size: 10, design: .rounded).weight(.semibold))
                                .foregroundColor(.black.opacity(0.2))
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 16)
                        }
                    }.onTapGesture {
                        Task{
                            await userViewModel.refresh()
                        }
                    }
                    Spacer()
                    // navigation bar
                    HStack(){
                        // is discoverable
                        Button{
                            if(userViewModel.userModel != nil){
                                isDiscoverable.toggle()
                                if(isDiscoverable){
                                    bluetoothManager.startAdvertising(id: userViewModel.userModel!.email!)
                                } else {
                                    bluetoothManager.stopAdvertising()
                                }
                            } else {
                                routeToProfile.toggle()
                            }
                        } label: {
                            VStack(spacing: 8){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(16)
                                        .foregroundColor(.white)
                                        .opacity(0.15)
                                    Image(systemName: isDiscoverable ? "eye" : "eye.slash")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                }
                                Text("Discoverable")
                                    .font(Font.system(size: 10, design: .rounded).weight(.regular))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        // is notifiable
                        Button{
                            if(userViewModel.userModel != nil){
                                isNotifiable.toggle()
                                if(isNotifiable){
                                    bluetoothManager.startScanDevices(targets: userViewModel.userModel!.lovedBy, play: notificationManager.playRingSound)
                                } else {
                                    bluetoothManager.stopAdvertising()
                                }
                            } else {
                                routeToProfile.toggle()
                            }
                        } label: {
                            VStack(spacing: 8){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(16)
                                        .foregroundColor(.white)
                                        .opacity(0.15)
                                    Image(systemName: isNotifiable ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                }
                                Text("Notification ")
                                    .font(Font.system(size: 10, design: .rounded).weight(.regular))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        // target button
                        NavigationLink( destination: TargetView(userViewModel: userViewModel), isActive: $routeToTarget){
                            EmptyView()
                        }
                        Button{
                            
                            if(userViewModel.userModel != nil){
                                routeToTarget.toggle()
                            } else {
                                routeToProfile.toggle()
                            }
                            print(routeToProfile)
                        } label: {
                            VStack(spacing: 8){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(16)
                                        .foregroundColor(.white)
                                        .opacity(0.15)
                                    Image(systemName: "heart.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                }
                                Text("Target")
                                    .font(Font.system(size: 10, design: .rounded).weight(.regular))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        // profile button
                        NavigationLink( destination: ProfileView(userViewModel: userViewModel), isActive: $routeToProfile){
                            EmptyView()
                        }
                        Button{
                            routeToProfile.toggle()
                            print(routeToProfile)
                        } label: {
                            VStack(spacing: 8){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(16)
                                        .foregroundColor(.white)
                                        .opacity(0.15)
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                }
                                Text("Profile")
                                    .font(Font.system(size: 10, design: .rounded).weight(.regular))
                                    .foregroundColor(.white)
                            }
                        }
                    }.padding(.horizontal, 24)
                }
                
            }
            
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("pink2"), Color("pink1")]), startPoint: .top, endPoint: .bottom)
                
            )
            .onAppear {
                startAnimation()
//                autoRefresh()
            }

        }.onAppear{
            
            Task{
                userViewModel.userTarget = await userViewModel.getUserByEmail(userViewModel.userModel?.target ?? "")
                print("email", userViewModel.userModel?.target)
                print(userViewModel.userTarget, "oooo")

            }
        }
        
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
