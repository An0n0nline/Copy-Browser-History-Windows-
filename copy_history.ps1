# Detect OneDrive Desktop folder
$oneDriveDesktop = "$env:USERPROFILE\OneDrive\Desktop\Web Browser History"

# Create destination folder if it doesn't exist
if (!(Test-Path $oneDriveDesktop)) { New-Item -ItemType Directory -Path $oneDriveDesktop }

# Function to copy a single file into a subfolder
function Copy-BrowserHistory($srcPath, $browserName) {
    if (Test-Path $srcPath) {
        $destFolder = Join-Path $oneDriveDesktop $browserName
        if (!(Test-Path $destFolder)) { New-Item -ItemType Directory -Path $destFolder }
        Copy-Item $srcPath $destFolder -Force
        Write-Host ("Copied ${browserName}: $srcPath → $destFolder")
    } else {
        Write-Host ("Skipped ${browserName}: file not found")
    }
}

# Firefox (loop over profiles)
$ffProfiles = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory
foreach ($p in $ffProfiles) {
    $ffFile = Join-Path $p.FullName "places.sqlite"
    Copy-BrowserHistory $ffFile "Firefox"
}

# Chrome-based browsers
Copy-BrowserHistory "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History" "Chrome"
Copy-BrowserHistory "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History" "Edge"
Copy-BrowserHistory "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\History" "Brave"
Copy-BrowserHistory "$env:APPDATA\Opera Software\Opera Stable\History" "Opera"

Write-Host "All done. Check your OneDrive Desktop\Web Browser History"
