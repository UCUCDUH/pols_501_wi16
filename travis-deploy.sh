#!/bin/bash
cd web && nikola github_deploy 2>&1 | sed -e "s/${GH_TOKEN}/XXXX/g"
