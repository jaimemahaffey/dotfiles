# Function to kill the process by name
function KillProcessByName {
    param (
        [string]$name
    )
    Get-Process -Name $name -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Process -Id $_.Id -Force
        Write-Host "Killed process: $($_.Name) with ID: $($_.Id)"
    }
}

# Function to kill the process by ID (if using process ID)
function KillProcessById {
    param (
        [int]$id
    )
    Stop-Process -Id $id -Force -ErrorAction SilentlyContinue
    Write-Host "Killed process with ID: $id"
}

# Function to run the command and check for errors
function RunAndCheckCommand {
    param (
        [string]$command,
        [string]$arguments
    )
    # Run the command and capture the output
    $process = Start-Process -FilePath $command -ArgumentList $arguments -NoNewWindow -PassThru -RedirectStandardOutput $outputFile -RedirectStandardError $errorFile
    #$process.WaitForExit()
    $output = Get-Content $outputFile
    $errorOutput = Get-Content $errorFile

   
        # Further check the output for specific error messages
        if ($output -match "Encountered Error in Keysource") {
            Write-Host "An error was detected in the command output."
            return $false
        } else {
            $process.WaitForExit();
            Write-Host "The command completed successfully."
            return $true
        
    }

}

# Define the name or ID of the process to monitor and potentially restart
$processName = "kmonad.exe"  # Use the process name
#$processId = 1234  # Alternatively, use the process ID

# Define the command to run
$command = "C:\Users\JMahaffey\AppData\Roaming\local\bin\kmonad.exe"
$arguments = "C:\utilities\kmonad\keymap.kbd -l debug"  # Any arguments for the command

# Get the path to the AppData directory
$appDataPath = [System.Environment]::GetFolderPath('ApplicationData')

# Create a subdirectory for your application (optional)
$appSubDir = Join-Path -Path $appDataPath -ChildPath "kmonad"
if (-not (Test-Path -Path $appSubDir)) {
    New-Item -Path $appSubDir -ItemType Directory
}

# Paths for output files
$outputFile = Join-Path -Path $appSubDir -ChildPath "output.txt"
$errorFile = Join-Path -Path $appSubDir -ChildPath "error.txt"

$retryCount = 0;
$numRetries = 5;
# Define the cleanup action
$cleanupAction = {
    Write-Host "Script is being terminated. Performing cleanup actions..."
    # Add your cleanup logic here
    # For example, kill a specific process or remove temporary files
    Get-Process -Name $processName -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Process -Id $_.Id -Force
        Write-Host "Killed process: $($_.Name) with ID: $($_.Id)"
    }
    # Remove temporary files
    
    
    if (Test-Path $outputFile) { Remove-Item $outputFile }
    if (Test-Path $errorFile) { Remove-Item $errorFile }
}

# Register the event handler for the engine stopping event
$null = Register-EngineEvent -SourceIdentifier "PowerShell.Exiting" -Action $cleanupAction

# Your main script logic goes here
try {
   


# Run the command and check for errors

do{

    if($retryCount -ge 1){
    # Kill the process by name (or by ID if using process ID)
    KillProcessByName -name $processName
    # Kill-ProcessById -id $processId

    # Pause briefly to ensure the process is terminated
    Start-Sleep -Seconds 2
}

$success2 = RunAndCheckCommand -command $command -arguments $arguments

$retryCount++;
    
}while((-not $success2) -and ($retryCount -lt $numRetries))




} catch {
    Write-Host "An error occurred: $_"
} finally {
    Write-Host "Script is ending."
}
