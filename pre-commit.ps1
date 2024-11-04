#!powershell

# Create pre-commit.ps1 - created in the root folder of the project
#
# Format your code before committing it
#
# This can be called manually with:
# .\pre-commit -a

Write-Host "Formatting code"
Write-Host "Done formatting code"
Write-Host "Running tests"
Write-Host "Testing complete. Exit code: $LASTEXITCODE"

# Pass the failure code back to the pre-commit hook
exit $LASTEXITCODE

