Start-Process powershell -Verb runAs
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex 
choco install -y packer
choco install -y virtualbox
choco install -y vagrant

