cmd /c git config --global alias.squash "!f(){ git reset --soft HEAD~${1} && git commit --edit -m\"$(git log --format=%%B --reverse HEAD..HEAD@{1})\"; };f"
cmd /c git config --global alias.lol "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
cmd /c git config --global user.email "mornymorny@gmail.com"
cmd /c git config --global user.name "Morny"

setx MYDROPBOX=c:\Dropbox
set nvim=so ~/AppData/Local/nvim/init.vim
echo %nvim% > %USERPROFILE%/.vimrc
cargo install ripgrep

REM Setup P4 review, might need to change both reg vars!!
REM \HKEY_CLASSES_ROOT\P4Review\shell\Review\command and \Open\command - check these have been set!
REM assoc .p4r=P4Review
REM ftype P4Review="e:\sw\tools\win32\ActivePerl\5.10.0.1004\bin\perl.exe" e:\sw\main\apps\p4review\p4review.pl -directory -diff "e:\\Dropbox\\Dev\\bin\\BCompare.exe" "%1" -diffargs "/solo"
