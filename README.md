
# Space Invader - IOS (SwiftUI)

Love Alarm Inspired is inspired by the Love Alarm application in the Korean drama series Love Alarm. The way it works is that we choose the person we like/want to ring the alarm for. When we are near that person, their Love Alarm will ring. If they choose us as well, our Love Alarm will also ring.

This application utilizes Apple's Bluetooth Low Energy (BLE) to advertise a unique device name data. This unique name will be recognized by other devices performing scans. If the unique name belongs to the person we like, it will trigger the alarm on their device.

Unfortunately, this application will only run if the user opens it. This is because BLE does not advertise the unique name data normally in the background. It doesn't advertise the unique name, but rather the service ID within the flow. Due to my limited capabilities, I haven't fully understood this flow and how to detect it.

I chose BLE over GPS because I believe BLE would be more energy-efficient than GPS. However, after the development, I realized that BLE has this limitation. After this, I will try to explore BLE again, and if it doesn't work, I might consider using GPS.

<img src="https://github.com/mrezkys/love-alarm-inspired/blob/main/love-alarm-inspired-banner.jpg" width="auto" height="auto" >

### Demo
Demo : [Youtube Video](https://youtube.com/shorts/rV7oue5fnUo)

### Framework
- SwiftUI
- CloudKit
- CoreBluetooth
- AVFoundation

### Credit
- [Muhammad Rezky Sulihin](https://www.facebook.com/mrezkys12) as Developer 
