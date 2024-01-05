# Get-Perm
Python and PowerShell tool that compares AD groups between two users.
*Only works on Windows OS
*Made for Active Directory environment domain
*Requires Python3

You'll need to change your PowerShell execution policy to allow local scripts to run if you haven't already.

PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Are you familiar with these situation where something works for one user but not the other?
Probably has something to do with user groups, but which one?
Get_Perm.py at your service.
Provide two usernames and this script will compare them and tell you the difference in their AD groups.
