$ErrorActionPreference = 'Stop'; 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://dl.uconomix.com/ExifPurge.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'exif-purge*' 
  checksum      = '4DA7C418D9C08D5A41141001B29F8EBED8CC8A6EE2ED2BAF22CE84BC4D9D65E9'
  checksumType  = 'sha256'
}

# Create folder in Program Files for the application and unzip to this
$programfiles = [Environment]::GetFolderPath("ProgramFiles")
$unzippath = Join-Path $programfiles $env:ChocolateyPackageTitle
Install-ChocolateyZipPackage $packageName $url $unzippath

$executable = "ExifPurge.exe"

# Add Desktop shortcut
$desktoppath = [Environment]::GetFolderPath("Desktop")
$shortcutfilename = "$env:ChocolateyPackageTitle.lnk"
$shortcutpath = Join-Path  $desktoppath $shortcutfilename
$executablepath = Join-Path $unzippath $executable
Install-ChocolateyShortcut -shortcutFilePath $shortcutpath -targetPath $executablepath

# Add StartMenu shortcut
$startmenupath = [Environment]::GetFolderPath('StartMenu')
$shortcutfilename = "$env:ChocolateyPackageTitle.lnk"
$shortcutpath = Join-Path  "$startmenupath\Programs" $shortcutfilename
$executablepath = Join-Path $unzippath $executable
Install-ChocolateyShortcut -shortcutFilePath $shortcutpath -targetPath $executablepath