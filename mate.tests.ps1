# Pester testing. https://github.com/pester/Pester/wiki
$myScript = "$PSScriptRoot\mate.psm1"

Describe 'Unit Tests' {
  Context 'Basic Validation' {
    it 'Should run successfully' {
      if ($myScript -like '*ps1') {
        $run = invoke-expression $myScript
      } else {
        import-module $myScript
        $runCommand = test-mate
      }

      $runCommand | Should Match "Reporting from"
    }
  }
}
