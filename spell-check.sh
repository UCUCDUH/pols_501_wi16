#!/bin/bash
#PATH=./node_modules/.bin:$PATH
#find web/stories -name "*.md" -exec mdspell --en-us -a -n -r {} \;

rc=0
find web/output -name "*.html" |
    while read filename; do
        misspellings=$(hunspell -d en_US,en_pols501 --check-apostrophe -H -l "$filename" 2>&1)
        if [ ! -z "$misspellings" ]
        then
            echo "ERROR: mispelled words in $filename"
            echo $misspellings | sort | uniq
            rc=$(($rc + 1))
        fi
    done
exit 0

