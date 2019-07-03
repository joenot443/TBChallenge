# TBChallenge
Challenge for TouchBistro.

## Instructions

Open the workspace, build, and run. Layout designed for iPhone size devices.

## Special Notes for Improvements

While I'm happy with the project in general, there are several areas I would have improved on if I had more time.

### Tests

I realize I wrote fairly minimal, happy-path test cases. I'm only testing the `MenuManager`, and I'm only testing adding the default menu, adding groups, and removing groups. In a perfect world, there are *many* additional test cases I'd like to write, but again, time was a restriction. In an onsite interview, I'd be happy to explain which cases I'd like to write.

### MenuEditDelegate

I'm not especially happy with the way I implemented this. Presently, it only triggers validation upon the keyboard attempting to return or dismiss. If I were to rewrite it, I'd definitely make the associated view controllers a bit more stateful, and validate automatically while editing. 

I'd also rewrite the `didFinishEditing` protocol to make it more type safe. Presently, there are a handful of force unwraps which I believe are safe, but I'm still not especially happy with.

### General Design

The design is very, very plain. It's functional, but is definitely nowhere close to what one would like for a real menu application.

## External Libraries Used

CocoaPods was used for package management.

### Toast-Swift

Awesome little library for adding toasts to UIViews. I used this for success and error messages.

### SDWebImage

Convenient category to UIImageView which makes it MUCH quicker to display and cache images from the web.
