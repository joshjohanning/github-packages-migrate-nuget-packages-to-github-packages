#!/bin/bash

# Usage: 
# 1. Generate mappings file: ./generate-nuget-package-mappings.sh . > packages.csv
# 2. Update the mappings file with the target GitHub repo in the format of "owner/repo"
# 3. Migrate the packages: ./migrate-nuget-packages-to-github.sh <mappings-file> <pat> <path-to-gpr>"

# Prereqs:
# 1. gpr: `dotnet tool install gpr -g` (https://github.com/jcansdale/gpr)
# 2. Can use this to find GPR path: `find / -wholename "*tools/gpr" 2> /dev/null`
# 3. `<pat>` must have `write:packages` scope
# 
# Passing `gpr` explicitly because sometimes `gpr` is aliased to `git pull --rebase` and that's not what we want here
#

# Tip:
# Find a list of nupkg's and copy them all to a directory
# ie: find / -name "*.nupkg" -exec cp "{}" ./new-folder  \;

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir=$1

results=$(find $dir -name "*.nupkg" | sort)

echo "Package,Target GitHub Repo"

for result in $results
do
    echo "$result,"
done
