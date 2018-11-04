function Test-mate {
  <#
  .SYNOPSIS
    Write a synopsis here
  .DESCRIPTION
    Write a description here
  .EXAMPLE
    C:\PS> test-mate
  .NOTES
    Author: JohnBruckler
    CreateDate: 11/02/2018 21:16:01
  #>
  [cmdletbinding()]
  [OutputType([String])]
  param()

  Write-Output "Reporting from test-mate function!"
}

# Import functions, classes
$ImportDirectories = @('Public','Private','Classes')

# dot-source all the PowerShell scripts and classes into the $script: scope
foreach ($ImportDirectory in $ImportDirectories) {
    $DirectoryPath = Join-Path -Path $PSScriptRoot -ChildPath $ImportDirectory
    Write-Verbose ('Import directory: {0}' -f $ImportDirectory)

    if (Test-Path -Path $DirectoryPath) {
        Write-Verbose -Message ('Importing from: {0}' -f $DirectoryPath)
        $Imports = Get-ChildItem -Path $DirectoryPath -Filter '*.ps1'

        foreach ($Import in $Imports) {
            Write-Verbose ('{0}Importing: {1}' -f '`t', $Import.BaseName)
            . $($Import.FullName)
        }
    }
}


# Export PUBLIC functions
$PublicExports = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public') -Filter *.ps1).BaseName
Export-ModuleMember -Function $PublicExports
