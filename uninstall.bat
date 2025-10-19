@echo off
chcp 1251 >nul

:: Сохраняем путь к текущему файлу
set "batfile=%~f0"

:: Проверка прав администратора
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Запрос прав администратора...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%batfile%", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs" >nul 2>&1
    exit /b
)

echo Права администратора получены.
echo.

echo Завершение процесса Everything.exe...
taskkill /f /im everything.exe >nul 2>&1

if %errorlevel% == 0 (
    echo Процесс Everything.exe успешно завершен.
) else (
    echo Процесс Everything.exe не найден или не был запущен.
)

echo.
echo Удаление папок с рабочего стола...

set "desktop=%USERPROFILE%\Desktop"

if exist "%desktop%\Tools" (
    rmdir /s /q "%desktop%\Tools"
    echo Папка Tools удалена.
) else (
    echo Папка Tools не найдена.
)

if exist "%desktop%\NordX Checker" (
    rmdir /s /q "%desktop%\NordX Checker"
    echo Папка NordX Checker удалена.
) else (
    echo Папка NordX Checker не найдена.
)

echo.
echo Операция завершена.
echo Файл будет автоматически закрыт и удален через 3 секунды...

:: Задержка перед закрытием
timeout /t 3 /nobreak >nul

:: Создаем временный bat файл для удаления основного
echo @echo off > "%temp%\delete_self.bat"
echo chcp 1251 >nul >> "%temp%\delete_self.bat"
echo timeout /t 1 /nobreak >nul >> "%temp%\delete_self.bat"
echo del /f /q "%batfile%" >> "%temp%\delete_self.bat"
echo del /f /q "%%~f0" >> "%temp%\delete_self.bat"

:: Запускаем удаление и выходим
start /b "" cmd /c "%temp%\delete_self.bat"
exit