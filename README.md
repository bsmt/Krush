Krush
=====
A framework that allows patching MachO binaries based on symbols and more.

Most of Krush is documented, you can view the documentation at http://bsmt.github.com/Krush. It may not be completely up to date, though.

Building requires Xcode 4.5 or newer.

Unit Tests
----------
To run the tests, first you need to get GHUnit:

    # In the Krush project directory:
    git submodule init
    git submodule update

Then, build and install GHUnit:

    cd GHUnit/Project-MacOSX
    make
    cp -r build/Release/GHUnit.framework ../../Tests/

Now you should be able to switch to the Tests target and run it.

Generating Documentation
------------------------

Krush is documented with [appledoc](http://gentlebytes.com/appledoc/).

If you want to generate documentation so that you can install it in Xcode, you'll need to get appledoc:

    brew install appledoc

Then, simply switch to the Documentation target in the Xcode project and build. It should install the documentation in Xcode and place the Docset and HTML versions in the KrushDocs folder on your Desktop.
