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

### 1️⃣ Running the Script
```powershell
.\CreatePacket.ps1 -packetName "YourPacketName"
