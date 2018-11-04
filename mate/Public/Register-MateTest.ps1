function Register-MateTest 
{
    <#
    .SYNOPSIS
    Registers Atomic tests for execution.
    
    .DESCRIPTION
    Takes a path to a test or directory of tests and registers them
    in memory for execution by Invoke-MateTest.
    
    .PARAMETER Path
    The path to a YAML file defining an Atomic Test, or a directory
    containing YAML files defining Atomic tests.
    
    .PARAMETER PassThru
    When provided, the test objects will be passed to the pipeline as
    well as registering them in memory.
    
    .EXAMPLE
    PS C:\> Register-MateTest -Path C:\tests

    The above command will register tests in memory.

    .EXAMPLE
    PS C:\> Register-MateTest -Path C:\tests\T1007\T1007.yml -PassThru

    Name                           Value
    ----                           -----
    description                    Adversaries may try to get information about registered services. Commands that may o...
    atomic_tests                   {System.Collections.Hashtable}
    display_name                   System Service Discovery
    attack_technique               T1007
    tactic                         Discovery

    The above command will register the T1007 test in memory, and also 
    outputs the T1007 information to the pipeline.
    
    .NOTES
    https://github.com/redcanaryco/atomic-red-team
    #>
    param(
        [Parameter( Mandatory = $true,
                    ValueFromPipeline = $true )]
        [string[]] $Path,
        [switch] $PassThru
    )

    begin {
        $Output = New-Object System.Collections.ArrayList
        $CurrentErrorAction = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
    }

    process {
        try {
            # If the provided path is a directory, recursively load all the
            # tests in the directory. Otherwise, just load the test defined
            # in the file provided.
            if ((Get-Item -Path $Path) -is [System.IO.DirectoryInfo]) {
                $Path = Get-ChildItem -Path $Path -Include *.yml, *.yaml -Recurse
            }

            foreach ($Item in $Path) {
                $Item = Get-Item $Item
                Write-Verbose ('Loading Attack test technique: {0}' -f $Item.BaseName)
                $TestDefinition = (Get-Content -Path $Item.FullName -Raw | ConvertFrom-Yaml)
                $null = $Output.Add($TestDefinition) 

                if ($PassThru) {
                    Write-Output $TestDefinition
                }
            }
        }
        finally {
            # Set the ErrorActionPreference back to what it was at the start of
            # this execution.
            $ErrorActionPreference = $CurrentErrorAction
        }
    }
}