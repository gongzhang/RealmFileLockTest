# RealmFileLockTest

This project demonstrates a specific issue encountered with Realm on visionOS. The app will 100% crash with either a 0xdead10cc error or a RUNNINGBOARD 3735883980 error upon entering the background, provided the following conditions are met:

1. The app utilizes @ObservedResults or any other Realm observation object.
2. The realm file is located in an App Group container.
3. The app is running on a physical Vision Pro device, not on a simulator.
4. The app is a native visionOS app, rather than an compatible iOS app.
5. The Xcode debugger is not attached to the app.

Under these specific circumstances, the app will 100% crash when it moves to the background.

## Steps to Reproduce

> Note: A **physical Vision Pro** is required to reproduce the crash.

1. Clone the repository and open the project in Xcode 15.3 or later.
2. Select a valid Team in the Signing & Capabilities section of the `RealmFileLockTest` target.
3. Set up a valid App Group identifier on the Signing & Capabilities page.
4. Update the App Group identifier in the code at [Main.swift#L14](https://github.com/gongzhang/RealmFileLockTest/blob/dfcdb32498f9c538de97d62d03a358880b5f3fd7/RealmFileLockTest/Main.swift#L14).
5. Build and run the app on a physical Vision Pro device.
6. Stop debugging in Xcode. (This step is crucial, as the crash will not occur if the debugger is attached.)
7. Reopen the app on the Vision Pro, and press the Digital Crown to return to the home screen. The app will crash in the background. (No message will be displayed on the screen, but if you reopen the app, you will notice it has cold started and the timer has reset.)
8. You can retrieve the crash log under Settings > Privacy > Analytics & Improvements > Analytics Data.

```log
Incident Identifier: A1FA1A77-0CC6-409B-B555-FFDDD2F26544
CrashReporter Key:   1b2668797ebb0d3ce434ac760fbcd8168635b1bb
Hardware Model:      RealityDevice14,1
Process:             RealmFileLockTest [756]
Path:                /private/var/containers/Bundle/Application/FA8A9582-4DAA-4600-BEB4-D24CC7740D31/RealmFileLockTest.app/RealmFileLockTest
Identifier:          io.gongzhang.RealmFileLockTest
Version:             1.0 (1)
Code Type:           ARM-64 (Native)
Role:                unknown
Parent Process:      launchd [1]
Coalition:           io.gongzhang.RealmFileLockTest [784]

Date/Time:           2024-03-27 15:37:11.8581 +0800
Launch Time:         2024-03-27 15:37:03.0253 +0800
OS Version:          xrOS 1.1.1 (21O224)
Release Type:        Beta
Report Version:      104

Exception Type:  EXC_CRASH (SIGKILL)
Exception Codes: 0x0000000000000000, 0x0000000000000000
Termination Reason: RUNNINGBOARD 3735883980 

Triggered by Thread:  0

Thread 0 name:   Dispatch queue: com.apple.main-thread
Thread 0 Crashed:
0   libsystem_kernel.dylib        	       0x24457a5c8 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x2445826b4 mach_msg2_internal + 80
2   libsystem_kernel.dylib        	       0x244582948 mach_msg_overwrite + 436
3   libsystem_kernel.dylib        	       0x244582788 mach_msg + 24
4   CoreFoundation                	       0x1a10e09b8 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x1a10dac70 __CFRunLoopRun + 1208
6   CoreFoundation                	       0x1a10da394 CFRunLoopRunSpecific + 608
7   GraphicsServices              	       0x1dc9da4f8 GSEventRunModal + 164
8   UIKitCore                     	       0x22c67c720 -[UIApplication _run] + 888
9   UIKitCore                     	       0x22c680f80 UIApplicationMain + 340
10  SwiftUI                       	       0x1b1c57ca8 0x1b0b28000 + 18021544
11  SwiftUI                       	       0x1b1c57b04 0x1b0b28000 + 18021124
12  SwiftUI                       	       0x1b18084f4 0x1b0b28000 + 13501684
13  RealmFileLockTest             	       0x1022bf060 static RealmFileLockTestApp.$main() + 40
14  RealmFileLockTest             	       0x1022bf10c main + 12
15  dyld                          	       0x23da918b8 start + 2204
...
```
