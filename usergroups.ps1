param([string]$user)
echo "The user $user is in:"
Get-LocalGroup | ForEach-Object {
    $group = $_.name
    Get-LocalGroupMember $group | ForEach-Object {
        if (($_.name.split("\")) -match $user) {
            echo $group
        }
    }
}