#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")/.."

# counterfeit all the things
echo
echo "Installing counterfeiter..."
echo
go install .

# counterfeit all the things
echo
echo "Generating fakes used by tests..."
echo
go generate ./...

# check that the fakes compile
echo
echo "Ensuring generated fakes compile..."
echo
go build -v ./...

# run the tests using the fakes
echo
echo "Running tests..."
echo
go test -race ./...

# remove any generated fakes
# this is important because users may have the repo
# checked out for a long time and acquire cruft.
# If they come back and git pull after a long time,
# and some of our internal interfaces have changed,
# they will likely have old generated fakes that reference
# files that no longer exist, breaking their local tests
echo
echo "Removing generated files..."
echo
find ./fixtures/ -path '*fakes/fake*.go' -print0 | xargs -0 rm -rf

echo "
 _______  _     _  _______  _______  _______
|       || | _ | ||       ||       ||       |
|  _____|| || || ||    ___||    ___||_     _|
| |_____ |       ||   |___ |   |___   |   |
|_____  ||       ||    ___||    ___|  |   |
 _____| ||   _   ||   |___ |   |___   |   |
|_______||__| |__||_______||_______|  |___|
 _______  __   __  ___   _______  _______
|       ||  | |  ||   | |       ||       |
|  _____||  | |  ||   | |_     _||    ___|
| |_____ |  |_|  ||   |   |   |  |   |___
|_____  ||       ||   |   |   |  |    ___|
 _____| ||       ||   |   |   |  |   |___
|_______||_______||___|   |___|  |_______|
 _______  __   __  _______  _______  _______  _______  _______
|       ||  | |  ||       ||       ||       ||       ||       |
|  _____||  | |  ||       ||       ||    ___||  _____||  _____|
| |_____ |  |_|  ||       ||       ||   |___ | |_____ | |_____
|_____  ||       ||      _||      _||    ___||_____  ||_____  |
 _____| ||       ||     |_ |     |_ |   |___  _____| | _____| |
|_______||_______||_______||_______||_______||_______||_______|
"
