#!/bin/bash

# Usage: 
# 1. Generate mappings file: ./generate-nuget-package-mappings.sh . > packages.csv
# 2. Update the mappings file with the target GitHub repo in the format of "owner/repo"
# 3. Migrate the packages: ./migrate-nuget-packages-to-github.sh <mappings-file> <pat> <path-to-gpr>"

# Prereqs:
# 1. gpr: `dotnet tool install gpr -g` (https://github.com/jcansdale/gpr)
# 2. Can use this to find GPR path: `find / -wholename "*tools/gpr" 2> /dev/null`
# 3. `<target-pat>` must have `write:packages` scope
# 
# Passing `gpr` explicitly because sometimes `gpr` is aliased to `git pull --rebase` and that's not what we want here
#

# Tip:
# Find a list of nupkg's and copy them all to a directory
# ie: find / -name "*.nupkg" -exec cp "{}" ./new-folder  \;

if [ -z "$3" ]; then
    echo "Usage: $0 <mappings-file> <pat> <path-to-gpr>"
    exit 1
fi

FILE=$1
PAT=$2
GPR_PATH=$3

# get contents of FILE
contents=$(cat $FILE)
# remove first line
contents=$(echo "$contents" | tail -n +2)
# for each package in contents
for package in $contents
do
    # echo "$package"
    # set source package name to first column
    package_name=$(echo "$package" | cut -d, -f1)
    # set target github repo to second column
    target_github_repo=$(echo "$package" | cut -d, -f2)
    echo "Migrating $package_name to $target_github_repo"
    eval $GPR_PATH push ./$package_name --repository https://github.com/$target_github_repo -k $PAT
done
