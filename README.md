# RealmFileLockTest

This project demonstrates a specific issue encountered with Realm on visionOS. The app will 100% crash with either a 0xdead10cc error or a RUNNINGBOARD 3735883980 error upon entering the background, provided the following conditions are met:

1. The app utilizes @ObservedResults or any other Realm observation object.
2. It is executed on an physical Vision Pro device, not on a simulator.
3. The app is a native visionOS app, rather than an compatible iOS app.
4. The Xcode debugger is not attached to the app.

Under these specific circumstances, the app will crash when it moves to the background.
