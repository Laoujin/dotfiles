Visual Studio
=============

Shortcuts
---------

Tools > Options > Environment > Keyboard


Add all mapped shortcuts here
- Edit.*
- Window.*
- File.Tfs*
- Team.Git.*


ATTN: Make sure you don't bind something to Ctrl C, X or Control C won't work anymore :)
(Same for Ctrl F, Ctrl A, ...)  
--> Make sure there is not a binding for the Ctrl "first" shortcut.


### General

- Tools.Options: Ctrl O, O (Open Options)
- Open Explorer
	- **In Code**: File.OpenContainingFolder: Ctrl O, F
	- **In Solution Explorer**: ProjectandSolutionContextMenus.Project.OpenFolderinFileExplorer: Ctrl O, D (Open Directory)
	- ???: File.OpenFolder: Ctrl Shift Alt O
- View.FullScreen: Shift Alt Enter
- Window.AutoHideAll: 
- Window.KeepTabOpen
- Tools.ExtensionsAndUpdates: Ctrl E, A (Extension Add)

- Tools.CodeSnippetsManager: Ctrl K, B
- File.NewSnippet

### Project Shortcuts

- Project.SetasStartUpProject: Ctrl S, P (StartUp Project) or Ctrl Alt R
- Build.PubishSelection: Ctrl P, P (Project Publish)
- ClassViewContextMenus.ClassViewProject.Debug.Startnewinstance: Ctrl D, S (Debug Start)
- File.AddExistingProject: Ctrl P, A (Project Add)
- File.AddNewProject: Ctrl P, N (Project New)
- File.NewProject: Ctrl Shift N
- File.OpenProject: Ctrl Shift O
- File.OpenWebSite: Shift Alt O
- Project.EditProjectFile: Ctrl P, E (Project Edit)
- Project.ExcludeFromProject: Ctrl P, X (Project eXclude)
- Project.IncludeInProject: Ctrl P, I (Project Include)
- Project.ReloadProject: Ctrl P, R (Project Reload)
- Project.ShowAllFiles: Ctrl P, H (Project Hidden)
- Project.UnloadProject: Ctrl P, U (Project Unload)
- File.CloseSolution: Ctrl P, C (Project Close)
- Project.AddReference: 
- Project.AddNewSolutionFolder: Ctrl P, F (Project Folder)


### File Shortcuts

- Project.AddExistingItem: Shift Alt A
- Project.AddNewItem: Ctrl N
	- Used to be bound to File.NewFile (but who uses that)  
	- Resharper: Alt+Ins to add class, enum, ...  
- Project.RunCustomTool: Ctrl R, T (Run Tool)
- View.OpenWith: 
- Window.CloseAllDocuments: 
- File.CloseAllButThis: 
- 


### Git

- Team.Git.ViewHistory: Ctrl G, H (Git History)
- Team.Git.Annotate: Ctrl G, B (Git Blame)
- Team.Git.CompareWithUnmodified: Ctrl G, U (Git Unmodified)

### TFS

- File.GetLastestVersion?
- File.TfsGetLastestVersion: Ctrl T, L (Tfs Latest) --> ReSharper already hooks in on the Ctrl + T
- File.TfsHistory: Ctrl T, H (Tfs History)


### Testing

- All tests in solution: Ctrl U, L
- Run tests in scope: Ctrl U, R
- Debug tests in scope: Ctrl U, D
- Repeat previous run: Ctrl U, U

## Build

- Build.Cancel: Ctrl B, C (Build Cancel)


## Debug

- Debug.Start: F5
- Debug.StartWithoutDebugging: Ctrl F5
- Debug.Restart: Ctrl Shift F5
- Debug.StopDebugging: Shift F5
- Debug.RunToCursor: Ctrl F10
- Debug.SetNextStatement: Ctrl Shift F10
- Debug.ShowNextStatement: Alt Num*
- Debug.StepInto: F11
- Debug.StepIntoCurrentProcess: Ctrl Alt F11
- Debug.StepOut: Shift F11
- Debug.StepOutCurrentProcess: Ctrl Shift Alt F11
- Debug.StepOver: F10
- Debug.StepOverCurrentProcess: Ctrl Alt F10

- Debug.ExceptionSettings: Ctrl Alt E
- Debug.Immediate: Ctrl Alt I
- Debug.QuickWatch: Ctrl Alt Q
- Debug.CallStack: Ctrl Alt C
- Debug.Watch1: Ctrl Alt W & 1

- Debug.AttachtoProcess: Ctrl Alt P
- Debug.ReattachtoProcess: Shift Alt P
- Debug.BreakAll: Ctrl Alt Break
- Debug.GoToDisassembly: Alt G

- Debug.Breakpoints: Ctrl Alt B
- Debug.DeleteAllBreakpoints: Ctrl Shift F9
- Debug.EnableBreakpoint: Ctrl F9
- Debug.ToggleBreakpoint: F9
- EditorContextMenus.CodeWindow.Breakpoint.BreakpointConditions: Alt F9 & C
- EditorContextMenus.CodeWindow.Breakpoint.BreakpointLabels: Alt F9 & L


- Debug.Memory1: Ctrl Alt M & 1
- Debug.ParallelStacks: Ctrl Shift D & S
- Debug.ParallelWatch1: Ctrl Shift D & 1
- Debug.Processes: Ctrl Alt Z
- Debug.Registers: Ctrl Alt G
- Debug.Tasks: Ctrl Shift D & K
- Debug.Threads: Ctrl Alt H
