@echo off
REM ================================================
REM Google Cloud Storage Backup Script by @samu.lls
REM ================================================

SET KEY_FILE={C:\Folder\chave.json}
SET BUCKET_NAME={bucket-name}
SET SOURCE_FOLDER={C:\Folder\Target-folder-for-backup}
SET DESTINATION_PATH={Name of folder in Google Cloud}

SET GCLOUD_PATH={C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin}
SET CLOUDSDK_PYTHON={C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\platform\bundledpython\python.exe}

REM ================================================
REM Don't modify below
REM ================================================

SET CLOUDSDK_CONFIG=C:\config-gcloud-lls\.gcloud
SET PATH=%GCLOUD_PATH%;%PATH%
SET LOG_FILE=%~dp0backup_log.txt

echo ============================================ > %LOG_FILE%
echo Backup started at %date% %time% >> %LOG_FILE%
echo ============================================ >> %LOG_FILE%
echo. >> %LOG_FILE%

echo Authenticating... >> %LOG_FILE%
call gcloud auth activate-service-account --key-file="%KEY_FILE%" >> %LOG_FILE% 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Authentication failed! >> %LOG_FILE%
    echo Authentication failed. Check log: %LOG_FILE%
    exit /b 1
)

echo Authentication successful >> %LOG_FILE%
echo. >> %LOG_FILE%

echo Starting backup... >> %LOG_FILE%
echo Source: %SOURCE_FOLDER% >> %LOG_FILE%
echo Destination: gs://%BUCKET_NAME%/%DESTINATION_PATH% >> %LOG_FILE%
echo. >> %LOG_FILE%

call gsutil -m rsync -r -d "%SOURCE_FOLDER%" "gs://%BUCKET_NAME%/%DESTINATION_PATH%" >> %LOG_FILE% 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo. >> %LOG_FILE%
    echo ERROR: Backup failed! >> %LOG_FILE%
    echo Backup failed. Check log: %LOG_FILE%
    pause
    exit /b 1
)

echo. >> %LOG_FILE%
echo ============================================ >> %LOG_FILE%
echo Backup Completo com Sucesso! %date% %time% >> %LOG_FILE%
echo ============================================ >> %LOG_FILE%

echo Backup Complete! LLS
echo Check log for details: %LOG_FILE%

exit /b