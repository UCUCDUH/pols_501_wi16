#!/bin/bash
#PATH=./node_modules/.bin:$PATH
#find web/stories -name "*.md" -exec mdspell --en-us -a -n -r {} \;

find . web/output -name "*.html" |
    while read file
    do
        filename="$file"
        echo "$file"
        misspellings=$(hunspell -d en_US,en_pols501 -H -l "$file")
        if [ -z "$mispellings" ]
        then
            exit 0
        else
            echo $misspellings
            exit 0
        fi
    done


