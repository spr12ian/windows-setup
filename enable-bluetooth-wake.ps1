# Requires: Run as Administrator

Write-Host "🔍 Checking for Bluetooth and HID devices..." -ForegroundColor Cyan

# Find all devices related to Bluetooth and HID (Human Interface Device)
$devices = Get-PnpDevice | Where-Object {
    $_.FriendlyName -match 'Bluetooth|HID' -and $_.Status -eq 'OK'
}

foreach ($device in $devices) {
    $name = $device.FriendlyName
    $instance = $device.InstanceId

    # Check if device can wake the system
    $canWake = powercfg -devicequery wake_from_any_device | Where-Object { $_ -eq $name }
    $isEnabledToWake = powercfg -devicequery wake_armed | Where-Object { $_ -eq $name }

    Write-Host "`n🖱️  Device: $name" -ForegroundColor Yellow
    Write-Host "    Instance ID: $instance"
    Write-Host "    Can Wake: $(if ($canWake) {'Yes'} else {'No'})"
    Write-Host "    Currently Enabled: $(if ($isEnabledToWake) {'Yes'} else {'No'})"

    if ($canWake -and -not $isEnabledToWake) {
        Write-Host "    ⚙️ Enabling wake support..." -ForegroundColor Green
        powercfg -deviceenablewake "$name" 2>$null
    }
}

Write-Host "`n✅ Done. Please test sleep and wake using your Bluetooth mouse." -ForegroundColor Cyan
