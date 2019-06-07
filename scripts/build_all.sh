#!/bin/bash
set -e

groups=`find . -maxdepth 1 -mindepth 1 -type d  | grep -v "scripts\|\.git\|build_artifacts"`
wd=`pwd`
artifacts="$wd/build_artifacts"
postfix="$(date +%Y-%m-%d_%H-%M-%S)-$(git describe --always)"
echo $postfix

for group in $groups; do
    echo Building $group

    input="$group"
    output="$artifacts/$group"
    mkdir -p $output

    cd "$input"
    find . -maxdepth 2 -mindepth 2 -name '*.tex' -print0 |
    while read -r -d $'\0' filename; do
        dir=`dirname "$filename"`
        file=`basename "$filename"`
        echo $'\tBuilding ' $file ' from ' $dir
        cd "$dir"
        latexmk -pdf "$file" || true

        pdf=`echo "$file" | sed 's/\.tex$/.pdf/g'`
        echo -n $'\tExpecting to find ' $pdf '...'
       
        target=`echo "$output/$dir.pdf" | sed 's#/\./#/#g'`
        if [ -f "$pdf" ]; then
            echo " ok"
            echo "Moving '$pdf' to '$target'"
            mv "$pdf" "$target"
            latexmk -C $file
        else
            echo " not found, exiting"
            exit 1
        fi
        cd ../
    done
    cd $artifacts && tar -cf "$artifacts/$group-$postfix.tar.gz" -C "$artifacts" "$group"
    cd $wd
done
find . -regex ".*\.\(snm\|cpc\|nav\)" -delete
find . -name "*eps-converted-to.pdf" -delete
