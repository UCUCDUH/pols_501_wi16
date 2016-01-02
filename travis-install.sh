#!/bin/bash
echo "https://${GH_TOKEN}@github.com/foo.git" 2>&1 | sed -e "s/${GH_TOKEN}/XXXX/g"
