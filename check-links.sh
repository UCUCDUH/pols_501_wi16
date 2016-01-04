#!/bin/bash
cd web
nikola build > /dev/null
bad_links=$(nikola check -l -r 2>&1 | grep "\(WARNING\|ERROR\):" )
if [ -z "$bad_links" ]
then
    echo "$bad_links"
    exit 1
else
    exit 0
fi

