@echo off
setlocal

rem Define the directories containing main.go files
set dirs=pa_obat pa_produk pa_stok_barang pa_stok_obat pa_user

rem Build the executables
for %%d in (%dirs%) do (
    echo Building %%d...
    cd %%d
    go build -o prog.exe main.go
    cd ..
)

rem Run the executables
for %%d in (%dirs%) do (
    start "Go Script %%d" cmd /c "%%d\prog.exe"
)

rem Wait for a key press to close all windows
echo Running all Go scripts. Press any key to stop...
pause > nul

rem Terminate all cmd windows started by this batch file
for %%d in (%dirs%) do (
    taskkill /FI "WINDOWTITLE eq Go Script %%d"
)

endlocal
