# QNAP Backup and Restore Powershell Script
This script help admin backup and restore user's data to and from QNAP network drive. This offers a conveninet way to store important files offsite and restore them when needed.

## Features

- **Automated connection to QNAP drive**: Easily connect to our QNAP network drive with user credentials.
- **Data Backup**: Backup specific directories such as Desktop, Documents, and Downloads.
- **Data Restoration**: Restore backed-up data from the QNAP drive to the local machine.
- **User Interface**: Simple menu-driven interface for ease of use.

## How It's Made:

**Tech used:**: Powershell

## Prerequisites
- Windows Powershell 5.1 or higher.
- Network access to a QNAP network drive.
- Modify the script to set the ```$qnapPath``` variable to the path of your QNAP network drive.

## Installation

- Download and place the script anywhere in directory

## Usage

- 1. Locate the script
- 2. Right-click on the script file and choose **Run with Powershell**
- 3. Follow the on-screen prompts to connect to the QNAP drive and choose between the options.

### Connecting to QNAP Drive
- You will be prompted to enter your QNAP network drive credentials

### 1. Perfoming a backup
- Choose the backup option from the menu.
- The script will automatically backup specified directories which is 3 folder Desktop, Documents, Downloads in C:\Users.

### 2. Restoring Data
- Choose the restore option from the menu.
- Specify the folder on the QNAP drive you wish to restore from.
- The script will restore data to the corresponding directories on your local machine.

## Customization
- Edit the ```$qnapPath``` variable to match the path of you QNAP network drive.
- Modify the ```$directories``` array to include or exclude directoies as per your requirement.

## Troubleshooting
- Ensure network connectivity to the QNAP drive.
- Verify that the paths specified in the script are accurate and accessible.
- Close all the File Explore are opening




