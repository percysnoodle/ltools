ltools
======

ltools is a collection of tools which help to localise an iOS app.  At the moment, it consists of a header file with some macros, and a ruby script which will check whether the strings that the app uses actually exist.

L.h
---

To use L.h, add it to your project, and import it from your PCH file.  You can then use the following macros:

```ObjC
NSString *myString1 = L(@"myKey"); // equivalent to NSLocalizedString(@"myKey", nil)
NSString *myString1 = LF(@"myFormattingKey", arg1, arg2); // equivalent to NSLocalizedString(@"arg1, arg2", arg1, arg2)
NSURL *myURL = LU(@"myURLKey"); // equivalent to [NSURL URLWithString:NSLocalizedString(@"myURLKey", nil)]
```

There are two advanteges to this: first, it is slightly quicker to type `L` than it is to type `NSLocalizedString`; and secondly it allows you to use L.sh.

L.rb
----

L.rb checks a strings file to see whether it contains all the keys defined in your app.  To use it, add a "Run Script" build phase to your target which calls L.rb for your project:

```ruby
ruby path/to/L.rb "My App.xcodeproj"
```

L.rb will inspect your project to find which files are included in a build, and to find where your localisable strings files are.

If you're using [CocoaPods](http://cocoapods.org), then the path to L.rb is `Pods/ltools/bin/L.rb`.  L.rb requires the 'xcodeproj' gem; if you're using cocoapods, then you already have it installed.

Once you've added the build phase, if you forget to include a key in one of your strings files, your build will fail.  Make sure you add the phase to every target that you want to check!


