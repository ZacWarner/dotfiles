##Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# comma separated list of packages to install
$Packages = 'git.install'

#Install Packages
ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

#Install Commandbox
$commandboxhome = "C:\Development\Tools\Commandbox\"
$commandboxurl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.4.2/commandbox-jre-win64-5.4.2.zip"
Invoke-Request -Uri $commandboxurl -OutFile ($commandboxhome + "src.zip")
Expand-Archive -LiteralPath ($commandboxhome + "src.zip") -DestinationPath $commandboxhome -Force
Delete-Item ($commandboxhome + "src.zip")
$PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")
$NEWPATH = $PATH + $commandbox 
[System.Environment]::SetEnvironmentVariable("PATH", $NEWPATH, "Machine")
"commandbox_home=$commandboxhome" | Out-File ($commandboxhome + "commandbox.properties")

#Install Commandbox Dependencies
#TODO: Service Manager ?
C:\commandbox\box.exe install commandbox-cfconfig, commandbox-dotenv, commandbox-hostupdater


#Clone Intranet
git clone https://psomas@bitbucket.org/psomaswebteam/psomas-intranet.git E:\sites\intra.psomas.com

#Clone Api
git clone https://psomas@bitbucket.org/psomaswebteam/intranet-api.git E:\sites\api.psomas.com


#Create/Start site via service manager
#service manager will use settings from server.json
cd E:\sites\intra.psomas.com
C:\commandbox\box.exe server start

cd E:\sites\api.psomas.com
C:\commandbox\box.exe server start

