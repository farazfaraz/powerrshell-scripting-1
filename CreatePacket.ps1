param (
    [string]$packetName
)

# Create the new PSDrive
New-PSDrive -Name U -PSProvider FileSystem -Root \\YOUR_DRIVE -Persist
# Infinite loop until correct values are entered
while ($true) {
    $product = Read-Host "Enter the product name"
    Write-Host $product
    if ($product -ne "" -and (Test-Path -Path U:\TMSArtifacts\$product -PathType Container)) {
        Write-Host "The product '$product' exists."  -ForegroundColor Green
        break  # Break out of the loop if product exists
    } else {
        Write-Host "The product '$product' does not exist. Please try again." -ForegroundColor Red
    }
}

while ($true) {
    $productBuild = Read-Host "Enter the product build"
    if ($productBuild -ne "" -and (Test-Path -Path U:\TMSArtifacts\$product\$productBuild -PathType Container)) {
        Write-Host "The build '$productBuild' exists for product '$product'."  -ForegroundColor Green
        break  # Break out of the loop if product build exists
    } else {
        Write-Host "The build '$productBuild' does not exist for product '$product'. Please try again." -ForegroundColor Red
    }
}

while ($true) {
    $project = Read-Host "Enter the project name"
    if ($project -ne "" -and (Test-Path -Path U:\TMSArtifacts\$project -PathType Container)) {
        Write-Host "The project '$project' exists."  -ForegroundColor Green
        break  # Break out of the loop if project exists
    } else {
        Write-Host "The project '$project' does not exist. Please try again." -ForegroundColor Red
    }
}

while ($true) {
    $projectBuild = Read-Host "Enter the project build"
    if ($projectBuild -ne "" -and (Test-Path -Path U:\TMSArtifacts\$project\$projectBuild -PathType Container)) {
        Write-Host "The build '$projectBuild' exists for project '$project'."  -ForegroundColor Green
        break  # Break out of the loop if project build exists
    } else {
        Write-Host "The build '$projectBuild' does not exist for project '$project'. Please try again." -ForegroundColor Red
    }
}

# Once all inputs are correct, proceed with the rest of the script
# Define paths
$productPath = "U:\TMSArtifacts\$product\$productBuild"
$projectPath = "U:\TMSArtifacts\$project\$projectBuild"
$destinationPath = "C:\Deployment\$packetName"

# List the files and directories on the mounted drive
#Get-ChildItem -Path $productPath

# Ensure the destination directory is clean
if (Test-Path -Path $destinationPath -PathType Container) {
    Remove-Item -Path $destinationPath -Recurse -Force
    Write-Host "Directory removed: $destinationPath" -ForegroundColor Yellow
}

# Create the destination directory if it doesn't exist
if (-Not (Test-Path -Path $destinationPath -PathType Container)) {
    New-Item -ItemType Directory -Path $destinationPath -Force
    Write-Host "Directory created: $destinationPath" -ForegroundColor Yellow
}

# Define the menu options
$menuOptions = @(
    "Option 1: Old Packet",
    "Option 2: New Packet",
    "Option 3: Exit"
)

function copyProductFiles {
    Write-Host "------------------------------------------------------PRODOTTO--------------------------------------------------"
    Write-Host "----------------------------------*.txt--------------------------------------------------"
    Get-ChildItem -Path $productPath -Recurse -Filter "*.txt" | ForEach-Object {
        # Join-Path: A cmdlet that combines multiple path segments into a single path.
        # The name of the current file ($_.Name) from the pipeline. $_ is an automatic variable that represents the current object in the pipeline.
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
        Write-Host "Copied $_.FullName to $destinationPath" -ForegroundColor Blue
    }
    Write-Host "----------------------------------*.msi--------------------------------------------------"
    Get-ChildItem -Path $productPath -Recurse -Filter "*.msi" | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
        Write-Host "Copied $_.FullName to $destinationPath" -ForegroundColor Blue
    }
    Write-Host "----------------------------------*.exe--------------------------------------------------"
    Get-ChildItem -Path $productPath -Recurse -Filter "*.exe" | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
        Write-Host "Copied $_.FullName to $destinationPath" -ForegroundColor Blue
    }
}

function copyProjectFiles {
    Write-Host "------------------------------------------------------PROGETTO--------------------------------------------------"
    Write-Host "----------------------------------*.txt--------------------------------------------------"
    Get-ChildItem -Path $projectPath -Recurse -Filter "*.txt" | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
        Write-Host "Copied $_.FullName to $destinationPath" -ForegroundColor Blue
    }
    Write-Host "----------------------------------*.exe--------------------------------------------------"
    Get-ChildItem -Path $projectPath -Recurse -Filter "*.exe" | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
        Write-Host "Copied $_.FullName to $destinationPath" -ForegroundColor Blue
    }
}

function new-packet {
    #PRODOTTO
    copyProductFiles
    #PROGETTO
    copyProjectFiles
    Write-Host "----------------------------------*.ps1--------------------------------------------------"
    Get-ChildItem -Path $productPath -Recurse -Filter "*.ps1" | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
        Write-Host "Copied $_.FullName to $destinationPath" -ForegroundColor Blue
    }
}

function old-packet {
    while ($true) {
    $installationPackageBuild = Read-Host "Enter the InstallationPackage'build number"
    if ($installationPackageBuild -ne "" -and (Test-Path -Path U:\TMSArtifacts\InstallationPackage\$installationPackageBuild -PathType Container)) {
        Write-Host "The build '$installationPackageBuild' exists for InstallationPackage." -ForegroundColor Green
        break
    } else {
        Write-Host "The build '$installationPackageBuild' does not exist for InstallationPackage. Please try again." -ForegroundColor Red
        }
    }
	printEnjoy
    # Check if the Deploy folder exists
    Write-Host "------------------------------------------------------DEPLOY FOLDER--------------------------------------------"
    $deployPath = "U:\TMSArtifacts\InstallationPackage\$installationPackageBuild\_InstallationPackage\build\Deploy"
    if (Test-Path -Path $deployPath -PathType Container) {
    Write-Host "Copying Deploy folder from $deployPath to $destinationPath"
    Copy-Item -Path $deployPath -Destination $destinationPath -Recurse -Force
    Write-Host "Copied Deploy folder to $destinationPath" -ForegroundColor Blue
    } else {
        Write-Host "Deploy folder does not exist at $deployPath" -ForegroundColor Red
    }

    copyProductFiles

    copyProjectFiles
}
# Function to display the menu and get user input
function Show-Menu {
    Write-Host "Select an option:"
    for ($i = 0; $i -lt $menuOptions.Length; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "Enter the number of your choice"
    return $selection
}

function printEnjoy {
	Write-Host "                             Z"             
	Write-Host "                       Z"                   
	Write-Host "        .,.,        z"           
	Write-Host "      (((((())    z"             
	Write-Host "     ((('_  _`) '"               
	Write-Host "     ((G   \ |)"                 
	Write-Host '    (((`   " ,'                  
	Write-Host "     .((\.:~:          .--------------."    
	Write-Host "     __.| `"'.__      | \              |"     
	Write-Host "  .~~   `---'   ~.    |  .             :"     
	Write-Host " /                `   |   `-.__________)"     
	Write-Host "|             ~       |  :             :"   
	Write-Host "|                     |  :  |           "   
	Write-Host "|    _                |     |   [ ##   :"   
	Write-Host " \    ~~-.            |  ,   oo_______.'"   
	Write-Host "  `_   ( \) _____/~~~~ `--___           "   
	Write-Host "  |   '///`  | `-.                "         
	Write-Host "  |     | |  |    `-.             "         
	Write-Host "  |     | |  |       `-.          "         
	Write-Host "  |     | |\ |                    "         
	Write-Host "  |     | | \|                    "         
	Write-Host "  `-.  | |  |                     "        
	Write-Host "      `-| '"
	Write-Host ""
	Write-Host "Sit down, relax and enjoy your pocket $packetName."
}

# Main script logic
while ($true) {
    $choice = Show-Menu
    switch ($choice) {
        1 {
            Write-Host "You selected Option 1: You have to be careful that the version must be 6.9.7 and below, Preparing old packet..." -ForegroundColor Green
            old-packet
            exit
        }
        2 {
            Write-Host "You selected Option 2: You have to be careful that the version must be 6.9.8 and up, Preparing new packet..." -ForegroundColor Green
			printEnjoy
            new-packet
            exit
        }
        3 {
            Write-Host "Exiting..."
            exit
        }
        default {
            Write-Host "Invalid selection. Please enter a number between 1 and $($menuOptions.Length)." -ForegroundColor Red
        }
    }
    }

# Remove the PSDrive
Remove-PSDrive -Name U