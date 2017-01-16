#!/bin/sh

# Usage
function usage {
    echo "$0 need 3 parameters"
    exit 1
}


# Read parameters
if [ ! $# -eq 3 ]; then
        usage
fi

sleep 10
echo "Sex:"$1

sleep 10
echo "echoStr:"$2

sleep 10
echo "echoDetail:"$3
