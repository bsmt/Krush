Krush
=====
A framework that allows patching MachO binaries based on symbols and more.

Currently patching isn't implemented, that's on the todo :P

Unit Tests
----------
To run the tests, first you need to install GHUnit:

    # In the Krush project directory:
    git submodule init
    git submodule update

Then, build and install GHUnit:

    cd GHUnit/Project-MacOSX
    cp -r build/Release/GHUnit.framework ../../Tests/

Now you should be able to switch to the Tests target and run it.
