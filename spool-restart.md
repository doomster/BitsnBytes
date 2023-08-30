restart spool service on windows , removing any print jobs in between.

create a bat file with the below code:


```
@echo off 
rem stop spooler 
net stop spooler 
rem pause 4 seconds 
ping -n 4 127.0.0.1 > null 
rem delete print jobs 
del /Q /F C:\\WINDOWS\\system32\\spool\\PRINTERS\\*.* 
pause 4 seconds 
ping -n 4 127.0.0.1 > null 
rem start spooler 
net start spooler 
echo done!

```
