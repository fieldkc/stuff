#K-Field

#Grab Enrollment GUID
$EnrollmentGUID = Get-ScheduledTask | Foreach-Object { $_.TaskPath -like "*Microsoft*Windows*EnterpriseMgmt\*" } | Select-Object -ExpandProperty TaskPath -Unique | Where-Object { $_ -like "*-*-*" } | Split-Path -Leaf

#Remove Enrollment GUID reg keys
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments\Status\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\Providers\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Provisioning\OMADM\Logger\$EnrollmentGUID" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions\$EnrollmentGUID" /f

#Create scheduled task to re-enroll
$action = New-ScheduledTaskAction -execute "%windir%\system32\deviceenroller.exe" -argument "/c /AutoEnrollMDM"
$trigger = new-scheduledtasktrigger -daily -at 9am
Register-ScheduledTask -user "System" -Action $action -Trigger $trigger -TaskName "Enroll"