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

License
-------

The MIT License (MIT)

Copyright (c) 2013 bsmt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/bsmt/krush/trend.png)](https://bitdeli.com/free "Bitdeli Badge")