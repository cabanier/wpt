#!/bin/bash
set -ex

SCRIPT_DIR=$(cd $(dirname "$0") && pwd -P)
WPT_ROOT=$SCRIPT_DIR/../..
cd $WPT_ROOT

test_infrastructure() {
    PY2_FLAG="$2"
    TERM=dumb ./wpt $PY2_FLAG run --log-mach - --yes --manifest ~/meta/MANIFEST.json --metadata infrastructure/metadata/ --install-fonts --install-webdriver $1 $PRODUCT infrastructure/
}

main() {
    if [[ $# -eq 1 && "$1" = "--py2" ]]; then
        PRODUCTS=( "firefox" "chrome" )
    else
        PRODUCTS=( "chrome" )
    fi
    ./wpt manifest --rebuild -p ~/meta/MANIFEST.json
    for PRODUCT in "${PRODUCTS[@]}"; do
        if [[ "$PRODUCT" == "chrome" ]]; then
            test_infrastructure "--binary=$(which google-chrome-unstable) --channel dev" "$1"
        else
            test_infrastructure "--binary=~/build/firefox/firefox" "$1"
        fi
    done
}

main $1
