@echo off
:: Jalankan sebagai administrator
cd /d %~dp0
powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb runAs"
exit

:main
:: Nonaktifkan fitur-fitur Windows Defender (Windows Security)
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
powershell -Command "Set-MpPreference -DisableIOAVProtection $true"
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true"
powershell -Command "Set-MpPreference -MAPSReporting 0"
powershell -Command "Set-MpPreference -SubmitSamplesConsent 2"
powershell -Command "Set-MpPreference -DisableIntrusionPreventionSystem $true"
powershell -Command "Set-MpPreference -DisableScriptScanning $true"
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

:: Dev Drive Protection (Windows 11+)
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\DevDrive" /v "EnableDevDriveProtection" /t REG_DWORD /d 0 /f

:: Tamper Protection Info (tidak bisa dimatikan via script langsung)
echo.
echo [!] Tamper Protection tidak bisa dimatikan via script. Harus manual di GUI:
echo     Windows Security > Virus & threat protection > Manage settings > Tamper Protection = OFF
echo.
pause
exit
