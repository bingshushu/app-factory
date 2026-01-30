@echo off
REM GIT快速提交命令
git add -A
set default_commit_message=update
set commit_message=%1
if "%commit_message%"=="" set commit_message=%default_commit_message%
git commit -m "%commit_message%"
for /f "tokens=*" %%i in ('git describe --contains --all HEAD') do set branch_name=%%i
git push origin %branch_name%
