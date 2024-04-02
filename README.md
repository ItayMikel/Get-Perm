# Get-Perm
PowerShell tool that compares AD groups between two users,
it dumps csv files with the requested users permissions for later review.

You'll need to change your PowerShell execution policy to allow local scripts to run.
PS> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Are you familiar with these situation where something works for one user but not the other?
Probably has something to do with user groups, but which one?
Get_Perm.py at your service.
Provide two usernames and this script will compare them and tell you the difference in their AD groups.
