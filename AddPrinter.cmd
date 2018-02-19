REM Remote install network printer for all users in system
REM Первый параметр - имя удалённого хоста
REM Второй параметр - путь к сетевому принтеру
REM Пример AddPrinter.cmd WorkstationName Server\Printer
rundll32 printui.dll,PrintUIEntry /ga /c \\%1 /n \\%2
start /wait sc \\%1 stop spooler
start /wait sc \\%1 start spooler