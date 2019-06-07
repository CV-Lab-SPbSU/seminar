#!/bin/bash
# XXX: Travis-CI has only outdated ubuntu distros (16.04 is the latest one)
# So we need to install some latex packages manually

set -e

function simple_install() {
    package=$1
    echo "Trying to install $1 from CTAN"
    wget http://mirrors.ctan.org/macros/latex/contrib/$1.zip
    unzip $1.zip
    mkdir -p /usr/local/share/texmf/tex/latex/$1
    cp $1/$1.sty /usr/local/share/texmf/tex/latex/$1
}

mkdir /tmp/ctan
cd /tmp/ctan

packages=(xcntperchap)

for package in $packages; do
    simple_install $package
done

texhash
