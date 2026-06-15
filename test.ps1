$Password = ConvertTo-SecureString -String "welcome22" -AsPlainText -Force 
$UserAccount = Get-LocalUser -Name "Administrator1"
$UserAccount | Set-LocalUser -Password $Password