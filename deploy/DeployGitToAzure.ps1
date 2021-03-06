param(
  [string]$rootpath
  ,[string]$reponame
  ,[string]$reposlotname
  ,[string]$distpath
  ,[string]$repopass
  ,[string]$repousername
)

Clear-Host
#$rootpath = "C:\GitHub\cwp"
#$reponame = "deployfromgit"
#$didistpathst = $rootpath + "\dist"

$date = Get-Date
$tempdir = "tempdirforgitpublishtoazure"
$repopath = $rootpath + "\" + $tempdir + "\" + $reponame
$repopathallfiles = $repopath + "\*"
$distallfiles = $distpath + "\*"
$azuregitrepouri = "https://" + $repousername + ":" + $repopass + "@" + $reposlotname + ".scm.azurewebsites.net:443/" + $reponame + ".git"

Set-Location -Path $rootpath
if (Test-Path -Path $tempdir) 
{
    Remove-Item -Path $tempdir -Confirm:$false -Recurse -Force
}
New-Item -ItemType directory -Path $tempdir
Set-Location -Path $tempdir

git config --global user.email "noreply@scania.com"
git config --global user.name "Auto Deploy User"

git clone $azuregitrepouri

Remove-Item $repopathallfiles 

Copy-Item $distallfiles $repopath

Set-Location $repopath
git add --all
git commit -m "Auto Commit"
git push $azuregitrepouri master

Set-Location -Path $rootpath