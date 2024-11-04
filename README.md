https://blog.nimblepros.com/blogs/setting-up-pre-commit-git-hook-on-windows-with-powershell/


What are Git Hooks?
Git Hooks are scripts that Git will execute when certain events happen. This allows you to hook into Git events and inject your own code to be executed during these events. These scripts live in the .git\hooks folder. These are the events that you can tap into.

applypatch-msg
commit-msg
fsmonitor-watchman
post-update
pre-applypatch
pre-commit
pre-merge-commit
pre-push
pre-rebase
pre-receive
prepare-commit-msg
push-to-checkout
update
Note: If you want a demo of these concepts using shell scripts without PowerShell, watch our YouTube video: Keep Your Repo Clean - Format & Test Using Git Hooks

Setup
For this demo, you will see that you can format code before committing and prevent committing broken tests. We have forked and cloned Ardalis.GuardClauses. We will intentionally fail a test and prevent the code from going in through the use of the pre-commit Git Hook.

As PowerShell is the primary scripting language on Windows, I would like to write a script in PowerShell that automatically formats my code and prevents me from checking in code with broken tests.

If you want to code-along with this post:

Fork Ardalis.GuardClauses into your own repositories.
Clone your fork locally.
Create a pre-commit PowerShell script
Git Hooks work as shell scripts. However, in a Windows environment, you may prefer to write your Git Hook scripts in PowerShell. In order to do that, you will have a shell script to call PowerShell to execute your custom script.

PowerShell
pre-commit
Git
System
User
PowerShell
pre-commit
Git
System
User
This is a shell script
Executes the PowerShell script
git commit
We have a commit
Time to do your thing
I need you to run this script
Here's the exit code
Done here

Notice that PowerShell has to include the exit code to the pre-commit hook. If it does not pass along the exit code, the git hook has no idea whether the PowerShell checks are successful. PowerShell can exit with the automatic variable $LASTEXITCODE to pass the exit code to the shell script.

Create the PowerShell script
The PowerShell script will:

Run dotnet format to format the code.
Run dotnet test to run the tests.
Exit with the exit code.
To create this:

Create a new file in the root of the solution called pre-commit.ps1.
Copy the code below and paste it into this file. Save the file.
#!powershell

# Create pre-commit.ps1 - created in the root folder of the project
#
# Format your code before committing it
#
# This can be called manually with:
# .\pre-commit -a

Write-Host "Formatting code"
dotnet format
Write-Host "Done formatting code"
Write-Host "Running tests"

dotnet test

Write-Host "Testing complete. Exit code: $LASTEXITCODE"

# Pass the failure code back to the pre-commit hook
exit $LASTEXITCODE
When you exit on an unsuccessful exit code - something greater than 0, the commit process will fail. The commit will not happen.

Create the pre-commit script
Now that you have a PowerShell script to execute, let’s set up the pre-commit Git Hook to run this script.

Navigate to the .git\hooks folder.
Rename pre-commit.sample to pre-commit.
Note: This is an extensionless file.

If there is anything in this file, empty the file.
Copy the following code to create a shell script that will execute a PowerShell script:
#!/bin/sh
echo 
exec powershell.exe -ExecutionPolicy RemoteSigned -File '.\pre-commit.ps1'
exit
At this point, you can intentionally fail a test and confirm that the commit is stopp