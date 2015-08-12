REM Define variables
set hostspath=%windir%\System32\drivers\etc\hosts
set appcmdpath=%windir%\System32\inetsrv
set sitedir="%CD%\Sources\Ornamental.Plastering.Web"
set project=ornamentalplastering
REM Delete site and pool
%appcmdpath%\appcmd.exe delete site /site.name:"zh-%project%"
%appcmdpath%\appcmd.exe delete apppool /apppool.name:"zh-%project%"

REM Create AppPool
%appcmdpath%\appcmd.exe add apppool /name:"zh-%project%"
%appcmdpath%\appcmd.exe set apppool /apppool.name:"zh-%project%" /processModel.identityType:NetworkService
%appcmdpath%\appcmd.exe set apppool /apppool.name:"zh-%project%" /enable32BitAppOnWin64:False
%appcmdpath%\appcmd.exe set apppool /apppool.name:"zh-%project%" /managedPipelineMode:Integrated
%appcmdpath%\appcmd.exe set apppool /apppool.name:"zh-%project%" /managedRuntimeVersion:v4.0
%appcmdpath%\appcmd.exe set apppool /apppool.name:"zh-%project%" /autoStart:True
%appcmdpath%\appcmd.exe start apppool /apppool.name:"zh-%project%"

REM Create site
%appcmdpath%\appcmd.exe add site /name:"zh-%project%" /physicalPath:"%sitedir%"
%appcmdpath%\appcmd.exe set app /app.name:"zh-%project%/" /applicationPool:"zh-%project%"

REM Define bindings (leave first as)
%appcmdpath%\appcmd set site /site.name:"zh-%project%" /+bindings.[protocol='http',bindingInformation='*:80:ornamentalplastering.local']
%appcmdpath%\appcmd set site /site.name:"zh-%project%" /+bindings.[protocol='http',bindingInformation='*:80:www.ornamentalplastering.local']

REM start site
%appcmdpath%\appcmd.exe start site /site.name:"zh-%project%"

@echo off
REM Add hosts to host file
echo. >> %hostspath%
echo 127.0.0.1		ornamentalplastering.local >> %hostspath%
echo 127.0.0.1		www.ornamentalplastering.local >> %hostspath%

echo. >> %hostspath%REM Creating maildrop
mkdir c:\temp\maildrop\