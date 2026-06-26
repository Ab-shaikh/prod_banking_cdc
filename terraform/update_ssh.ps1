# D:\prod_banking_cdc\terraform\update_ssh.ps1

$dns = terraform output -raw instance_public_dns

if (-not $dns) {
    Write-Host "❌ Could not get DNS from Terraform output. Did you run terraform apply?" -ForegroundColor Red
    exit 1
}

$sshConfigPath = "$env:USERPROFILE\.ssh\config"
$hostAlias = "airflow-user"
# Apna .pem file ka exact path yahan daalein (e.g., C:\Users\YourName\Downloads\raisa.pem)
$keyPath = "D:/data engineering material/pdf file and books/raisa.pem" 

# Agar config file nahi hai toh nayi banao
if (-not (Test-Path $sshConfigPath)) {
    New-Item -ItemType File -Path $sshConfigPath -Force | Out-Null
}

$lines = Get-Content $sshConfigPath
$newLines = @()
$inBlock = $false
$found = $false

foreach ($line in $lines) {
    if ($line -match "^Host $hostAlias\b") {
        $inBlock = $true
        $found = $true
        $newLines += $line
    }
    elseif ($inBlock -and $line -match "^\s*HostName\s+") {
        $newLines += "    HostName $dns"
        $inBlock = $false
    }
    else {
        $newLines += $line
    }
}

# Agar airflow-user pehle se nahi tha, toh naya block add karo
if (-not $found) {
    $newLines += ""
    $newLines += "Host $hostAlias"
    $newLines += "    HostName $dns"
    $newLines += "    User ubuntu"
    $newLines += "    IdentityFile $keyPath"
}

$newLines | Set-Content $sshConfigPath
Write-Host "✅ VS Code SSH Config Updated Successfully!" -ForegroundColor Green
Write-Host "👉 HostName is now set to: $dns" -ForegroundColor Cyan