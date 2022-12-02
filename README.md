# Migrate NuGet Packages to GitHub Packages

Migrate NuGet packages from another source (such as Azure Artifacts, Artifactory, etc.) to GitHub Packages

## Prerequisites

1. [gpr](https://github.com/jcansdale/gpr) installed: `dotnet tool install gpr -g`
2. Can use this to find GPR path for `<path-to-gpr>`: `find / -wholename "*tools/gpr" 2> /dev/null`
3. `<pat>` must have `write:packages` scope

Passing `gpr` as a parameter explicitly because sometimes `gpr` is aliased to `git pull --rebase` and that's not what we want here

## Usage

### Generate the Mappings File

This finds all `.nupkg` files in the current directory and generates a mappings `csv` file.

```bash
./generate-nuget-package-mappings.sh \
  . \
  > <mappings-file>
```

Afterwards, you need to edit the `csv` file to add the target GitHub repo reference, in the form of `owner/repo`.

Leave a trailing space at the end of the csv file.

### Migrate the Packages

This pushes the packages to the mapped GitHub repo:

```bash
./migrate-nuget-packages-to-github.sh \
  <mappings-file> \
  <pat> \
  <path-to-gpr>
```

## Example

```bash
# 1. generate mappings file
./generate-nuget-package-mappings.sh \
  . \
  > packages.csv

# 2. edit the mappings file to add owner/repo of github repo

# 3. push packages
./migrate-nuget-packages-between-orgs.sh \
  packages.csv \
  ghp_xyz \
  /home/codespace/.dotnet/tools/gpr
```

<details>

<summary>Example output</summary>

    Migrating ./nunit3.dotnetnew.template.1.7.0.nupkg to joshjohanning-org-packages-migrated/packages-repo2
    Found 1 package.
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo2. Version: 1.7.0. Size: 20949 bytes. 
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Uploading package.
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Successfully registered nuget package: NUnit3.DotNetNew.Template (1.7.0)

    Migrating ./newtonsoft.json.11.0.2.nupkg to joshjohanning-org-packages-migrated/packages-repo1
    Found 1 package.
    [Newtonsoft.Json.11.0.2.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo1. Version: 11.0.2. Size: 2407596 bytes. 
    [Newtonsoft.Json.11.0.2.nupkg]: Uploading package.
    [Newtonsoft.Json.11.0.2.nupkg]: Successfully registered nuget package: Newtonsoft.Json (11.0.2)
</details>

## Notes

- Uses [jcansdale/gpr](https://github.com/jcansdale/gpr) to do the nuget push
- Tip: Find a list of nupkg's and copy them all to a directory
  ```bash
  find / -name "*.nupkg" -exec cp "{}" ./new-folder  \;
  ```
