ltools
======

ltools is a collection of tools which help to localise an iOS app.  At the moment, it consists of a header file with some macros, and a shell script which will check whether the strings that the app uses actually exist.

L.h
---

To use L.h, add it to your project, and import it from your PCH file.  You can then use the following macros:

```ObjC
NSString *myString1 = L(@"myKey"); // equivalent to NSLocalizedString(@"myKey", nil)
NSString *myString1 = LF(@"myFormattingKey", arg1, arg2); // equivalent to NSLocalizedString(@"arg1, arg2", arg1, arg2)
NSURL *myURL = LU(@"myURLKey"); // equivalent to [NSURL URLWithString:NSLocalizedString(@"myURLKey", nil)]
```

There are two advanteges to this: first, it is slightly quicker to type `L` than it is to type `NSLocalizedString`; and secondly it allows you to use L.sh.

L.sh
----

L.sh checks a strings file to see whether it contains all the keys defined in your app.  To use it, add a "Run Script" build phase to your target which calls L.sh for each of your strings files:

```sh
(! sh path/to/L.sh "My App/en.lproj/Localizable.strings" | grep -E '^-"') &&
(! sh path/to/L.sh "My App/pt.lproj/Localizable.strings" | grep -E '^-"')
# ... and so on.
```

If you're using CocoaPods, then the path to L.sh is ``.

Once you've added the build phase, if you forget to include a key in one of your strings files, your build will fail.  Make sure you add the phase to every target that you want to check!


