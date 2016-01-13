#!/bin/bash
# Diffs of main pages
if [ ! -d "web/files" ]
then
    mkdir web/files
fi
git log -p --full-diff --since="2016-01-08" -- web/stories/schedule.md > web/files/schedule-diff.txt
git log -p --full-diff --since="2016-01-08" -- web/stories/index.md > web/files/index-diff.txt
