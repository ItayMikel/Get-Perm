# Welcome message
Write-Host @"
   /$$$$$$                                   /$$                    /$$                           /$$$$$$$$                  /$$
  | $$__  $$                                 |__/                   |__/                          |__  $$__/                 | $$
  | $$  \ $$ /$$$$$$   /$$$$$$  /$$$$$$/$$$$  /$$  /$$$$$$$ /$$$$$$$ /$$  /$$$$$$  /$$$$$$$          | $$  /$$$$$$   /$$$$$$ | $$
  | $$$$$$$//$$__  $$ /$$__  $$| $$_  $$_  $$| $$ /$$_____//$$_____/| $$ /$$__  $$| $$__  $$         | $$ /$$__  $$ /$$__  $$| $$
  | $$____/| $$$$$$$$| $$  \__/| $$ \ $$ \ $$| $$|  $$$$$$|  $$$$$$ | $$| $$  \ $$| $$  \ $$         | $$| $$  \ $$| $$  \ $$| $$
  | $$     | $$_____/| $$      | $$ | $$ | $$| $$ \____  $$\____  $$| $$| $$  | $$| $$  | $$         | $$| $$  | $$| $$  | $$| $$
  | $$     |  $$$$$$$| $$      | $$ | $$ | $$| $$ /$$$$$$$//$$$$$$$/| $$|  $$$$$$/| $$  | $$         | $$|  $$$$$$/|  $$$$$$/| $$
  |__/      \_______/|__/      |__/ |__/ |__/|__/|_______/|_______/ |__/ \______/ |__/  |__/         |__/ \______/  \______/ |__/

                      ,--.    ,--.
                     ((O ))--((O ))
                   ,'_`--'____`--'_`.
                  _:  ____________  :_
                 | | ||::::::::::|| | |
                 | | ||::::::::::|| | |
                 | | ||::::::::::|| | |
                 |_| |/__________\| |_|
                   |________________|
                __..-'            `-..__
             .-| : .----------------. : |-.
           ,\ || | |\______________/| | || /.
          /`.\:| | ||  __  __  __  || | |;/,.. 
         :`-._\;.| || '--''--''--' || |,:/_.-':
         |    :  | || .----------. || |  :    |
         |    |  | || '--ItayM---' || |  |    |
         |    |  | ||   _   _   _  || |  |    |
         :,--.;  | ||  (_) (_) (_) || |  :,--.;
         (`-'|)  | ||______________|| |  (|`-')
          `--'   | |/______________\| |   `--'
                 |____________________|
                  `.________________,'
                   (_______)(_______)
                   (_______)(_______)
                   (_______)(_______)
                   (_______)(_______)
                  |        ||        |
                  '--------''--------'


Welcome to Permission comparison tool by Itay Mikel!"
This program dumps csv files in the path 'C:/users/$env:Username/Get_Perm' with the requested users permissions
"@

Start-Sleep -Seconds 1

# Acquire users to compare
$a_usr = Read-Host "Please enter the first username"
$b_usr = Read-Host "Please enter the second username"
Write-Host "
Working on it..."

# Check if dump folder exist, create it if not
if (-not (Test-Path "C:/users/$env:Username/Get_Perm")) {
    New-Item -ItemType Directory -Path "C:/users/$env:Username/Get_Perm" | Out-Null
}

# Get AD user memberships and save to files
Get-ADUser $a_usr -Properties MemberOf | Select-Object -ExpandProperty MemberOf |
    ForEach-Object { ($_ -replace '^CN=([^,]+).+$','$1') | Sort-Object | Out-File -Encoding utf8 "C:/users/$env:Username/Get_Perm/$a_usr.csv" -Append }

Get-ADUser $b_usr -Properties MemberOf | Select-Object -ExpandProperty MemberOf |
    ForEach-Object { ($_ -replace '^CN=([^,]+).+$','$1') | Sort-Object | Out-File -Encoding utf8 "C:/users/$env:Username/Get_Perm/$b_usr.csv" -Append }

Write-Host "Permissions gathered successfully!"

# Read files and compare permissions
$a_usr_perms = Get-Content "C:/users/$env:Username/Get_Perm/$a_usr.csv" | Sort-Object -Unique
$b_usr_perms = Get-Content "C:/users/$env:Username/Get_Perm/$b_usr.csv" | Sort-Object -Unique

Write-Host "`n$a_usr is a member of these groups that $b_usr isn't a member of: "
Compare-Object -ReferenceObject $b_usr_perms -DifferenceObject $a_usr_perms | Where-Object { $_.SideIndicator -eq '=>' } | ForEach-Object { Write-Host $_.InputObject }

Write-Host "`n$b_usr is a member of these groups that $a_usr isn't a member of: "
Compare-Object -ReferenceObject $b_usr_perms -DifferenceObject $a_usr_perms | Where-Object { $_.SideIndicator -eq '<=' } | ForEach-Object { Write-Host $_.InputObject }

Start-Sleep -Seconds 2

Write-Host "
--------
Don't forget to clean up 'C:\users\$env:Username\Get_Perm' once in a while.
--------
"
Pause
Write-Host "Bye"
