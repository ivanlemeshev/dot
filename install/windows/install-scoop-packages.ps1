Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expressionchoco

scoop update --all

scoop bucket add extras

scoop install extras/rio
