$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'exif-purge*' 
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)" 

    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    }
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}

# Remove the program's folder from Program Files
$programfiles = [Environment]::GetFolderPath("ProgramFiles")
$unzippath = Join-Path $programfiles $env:ChocolateyPackageTitle
Remove-Item $unzippath -Recurse

# Remove Start Menu shortcut
$startmenupath = [Environment]::GetFolderPath('StartMenu')
$shortcutfilename = "$env:ChocolateyPackageTitle.lnk"
$shortcutpath = Join-Path  "$startmenupath\Programs" $shortcutfilename
Remove-Item $shortcutpath -Recurse

# Remove Desktop shortcut
$desktoppath = [Environment]::GetFolderPath("Desktop")
$shortcutfilename = "$env:ChocolateyPackageTitle.lnk"
$shortcutpath = Join-Path  $desktoppath $shortcutfilename
Remove-Item $shortcutpath -Recurse