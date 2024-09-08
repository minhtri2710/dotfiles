#UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#Terminal Icons
Import-Module Terminal-Icons

#Oh My Posh
oh-my-posh init pwsh --config 'C:\Users\tranm\AppData\Local\Programs\oh-my-posh\themes\takuya.omp.json' | Invoke-Expression

#PSReadLine
Set-PSReadLineOption -Editmode Emacs
Set-PSReadLineOption -BellStyle None 
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

#Alias
Set-Alias g git
Set-Alias vim nvim
Set-Alias tig 'C:\Users\tranm\scoop\apps\git\2.40.1.windows.1\usr\bin\tig.exe'
Set-Alias less 'C:\Users\tranm\scoop\apps\git\2.40.1.windows.1\usr\bin\less.exe'
Set-Alias grep findstr
Set-Alias ll eza
Set-Alias lg lazygit
Set-Alias ':q' exit

#Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue 
}

#Register ArgumentCompleter
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# ExitFunction
function exit {
  Invoke-Command -ScriptBlock {exit}
}

