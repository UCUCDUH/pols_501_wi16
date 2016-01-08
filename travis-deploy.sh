#!/bin/bash
set -e # exit with nonzero if anything fails

# This force pushes build directory and overwrites the gh-pages branch on github
# destroying all the history.
cd web
nikola build
cd output
git init
git add .
git commit -m "Travis update"
git push -f "https://${GH_TOKEN}@github.com/${GH_REF}/" master:gh-pages 2>&1 | sed -e "s/${GH_TOKEN}/XXXX/g"
