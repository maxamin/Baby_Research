# Define the folder path and file name
$folderPath = "C:\Path\To\Your\Folder"
$fileName = "FairplayKD.sys"
$fullPath = Join-Path -Path $folderPath -ChildPath $fileName

# Check if the file already exists
if (Test-Path $fullPath) {
    Write-Host "$fileName already exists in $folderPath"
} else {
    # Create an empty file
    New-Item -ItemType File -Path $fullPath -Force

    # Deny write access to the file
    $acl = Get-Acl $fullPath
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "WriteData", "Deny")
    $acl.AddAccessRule($rule)
    Set-Acl -Path $fullPath -AclObject $acl

    Write-Host "$fileName denied creation in $folderPath"
}
