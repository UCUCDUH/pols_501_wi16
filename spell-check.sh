#!/bin/bash
PATH=./node_modules/.bin:$PATH
find web/stories -name "*.md" -exec mdspell --en-us -a -n -r {} \;
