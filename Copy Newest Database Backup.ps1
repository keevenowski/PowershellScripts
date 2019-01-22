#--------------------------------------------------------------------------------------------
#   Title:    Copy Newest Database Backup
#   Created:  XX
#   Author:   XX
#   Purpose:  Gets the newest bak file and copies it from source to destination directories.
#--------------------------------------------------------------------------------------------

# returns the newest bak file name for a given folder
function GetLatestFile
{
    [OutputType([String])]
    Param ($path)

    $filter="*.bak"
    $latest = Get-ChildItem -Path $path -Filter $filter | Sort-Object LastAccessTime -Descending | Select-Object -First 1
    $latest.name
}

# declare and set local variables
$sourceFilePath = "\\SERVER\FOLDER\"
$destFilePath = "\\SERVER\FOLDER\"
$fileNamePrefix = "FILEPREFIXGOESHERE"
$sourceFileName = ""
$destFileName = ""

# get newest bak file name from the source directory
$sourceFileName = $sourceFilePath + (GetLatestFile -path $sourceFilePath)

if($sourceFileName -ne "")
{
    $timestamp = (Get-Date -UFormat "%Y%m%d");
    Write-Output ("Newest BAK is " + $sourceFileName)
    
    $destFileName = ($destFilePath + $fileNamePrefix + $timestamp + ".bak")
    Write-Output ("Copying BAK from " + $sourceFileName + " to " + $destFileName)

    # copy newest bak file from source to destination directory
    Copy-Item -Path ($sourceFileName) -Destination ($destFileName) -Force
}
else
{
   throw "File not found: $sourceFileName" # raise file not found error
}