# FileAutomationLab

`FileAutomation.ps1` sorts files from `Samples/Inbox` into `Samples/Organized`, using each file extension as its destination folder. Temporary `.tmp` files are skipped.

Preview the planned operations without changing files:

```powershell
./FileAutomation.ps1 -WhatIf
```

Run the automation:

```powershell
./FileAutomation.ps1
```

The `.gitignore` excludes temporary `.tmp` files, the `logs/` folder, and generated organized output. The tracked inbox samples remain available to run the script again after cloning.