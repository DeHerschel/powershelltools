param([string]$user)

$accounts = Get-LocalUser

foreach ($account in $accounts) {
    if ($account.name -eq $user ) {
        $exists = $true;
        break
    } 
}
if (!$exists) {
    echo "User not found."
    exit 2
}

$lastlog = (Get-LocalUser -Name $user).lastlogon 
$lastpasswordchange = (Get-LocalUser -Name $user).PasswordChangeableDate
$sid = (Get-LocalUser $user).SID
$enabled = (Get-LocalUser $user).enabled

if ((Get-WinSystemLocale).name -eq "es-ES") {
    $admins = Get-LocalGroupMember Administradores 
}
else {
    $admins = Get-LocalGroupMember Administrators 
}
foreach ($admin_user in $admins) {
    if ($admin_user.name -match $user) {
        $admin = $true
    }
}

echo "User:                    $user"
echo "Last Logon:              $lastlog"
echo "Last password change:    $lastpasswordchange"
echo "SID:                     $sid"
echo "Enabled:                 $enabled"
echo "Admin:                   $admin"