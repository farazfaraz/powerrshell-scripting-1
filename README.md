# Create Package Script

## Overview
This PowerShell script facilitates the deployment process by:
- Connecting to a network drive.
- Allowing users to select a **product** and **project**.
- Copying relevant files to a **local deployment folder**.
- Supporting both **old and new packet versions**.
- Ensuring a structured and automated deployment.

## Features
- **User Input Validation**: Ensures correct selection of products and builds.
- **File Copy Automation**: Transfers `.txt`, `.msi`, `.exe`, and `.ps1` files to the deployment folder.
- **Dynamic Deployment Options**: Supports both **old** and **new packet** structures.
- **Fun Easter Egg**: Enjoy ASCII art at the end of the process!

## Requirements
- Windows OS with PowerShell.
- Access to the network share `\\YOUR_DRIVE\TMSArtifacts`.
- Proper permissions to create and delete folders/files.

## Usage

### 1 Running the Script
```powershell
.\CreatePacket.ps1 -packetName "YourPacketName"
```

### 2 Enter the product name:
- If you are using branch 6.9.6, enter CreateDelivery.CI.Generic or other product names.
- If you are using the development branch, enter CreateBundles.

### 3 Enter the build number:
- This is the name of the folder inside the product folder.
- Example: 20250218.2.
