Developing using PowerShell in VS Code
======================================

https://blogs.technet.microsoft.com/heyscriptingguy/2016/12/05/get-started-with-powershell-development-in-visual-studio-code/
https://blogs.technet.microsoft.com/heyscriptingguy/2017/01/11/visual-studio-code-editing-features-for-powershell-development-part-1/
https://blogs.technet.microsoft.com/heyscriptingguy/2017/01/12/visual-studio-code-editing-features-for-powershell-development0-part-2/
https://blogs.technet.microsoft.com/heyscriptingguy/2017/02/06/debugging-powershell-script-in-visual-studio-code-part-1/

https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/using-vscode.mod


Plaster Project Scaffolding


Setting up in vs code

Cmd Pallete (Ctrl+Shft+P)
New Powershell manifest module (specify path, module & version name)

(Ctrl+Shft+O) - Document symbols (functions)


Powershell integrated console



Debugging

.vscode/launch.json (has configuration including debugging settings)


Enable PowerShell Interactive session (debugger pane)

Hit F5 to start debugging
Set the Breakpoint
call the Get-BreakPoint (gets list of breakpoints)

Load the module and call the method (with breakpoint)

Can see call-stacks, variables and set 'watch'


VS Code Tasks System

.vscode/tasks.json
double check the version key, set to 2.0.0
psake is a build automation tool for powershell

Cmd Pallete (Ctrl+Shft+P) - use for run test task



PSScriptAnalyzer (https://github.com/PowerShell/PSScriptAnalyzer)





Troubleshooting

1. Cannot run a document in the middle of a pipeline
make sure to have launch.json and specify
the launch parameters

for now can't run from a psm1 file, but can run from ps1



























