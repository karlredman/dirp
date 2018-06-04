# Project: dirp

A bash script for managing dirs, pushd, and popd across terminals and systems.

Author: [Karl N. Redman](https://karlredman.github.io/)

dirp provides an easy way to traverse and store complex and lengthy directory locations for current and future use in groups. dirp allows you to leverage the power of `dirs`, `pushd` and `popd` on a per group basis.  With dirp you can share your command line paths between terminals easily. And, through the use of `git` and `ssh`, it is a method of synchronizing your command line path groups/lists across different computers.

## Current Features:

See the same list of features with examples [here]().

* List and select directories managed by `dirs` in alternating colors in groups.
* Simplified directory traversal and usage.
* Simplified aliases (optional).
* CLI Menu driven interface (via bash select).
* Easily switch between directory groups (i.e. projects).
* Automatically sorts directory listings.
    * Versioned-text aware.
    * Alphanumeric.
    * Handles directory names that use spaces.
* New terminals automatically load the latest directory group.
* Create and delete directory groups easily.
* Colors and application behavior managed by environment variables.
* Short list of commands.
* Command tips (disabled via environment variable).


## Screenshots:
![dirp animated gif](https://github.com/karlredman/dirp/blob/master/docs/screenshot.gif?raw=true "dirp Screenshot")

## asciinema Session:

## Installation:

### Short Examples/Usage:
* More information in the wiki [Examples Section]()

## Command Usage:

| command         | description                                   |
| ---             | ---                                           |
| dirp            | main menu interface                           |
| dirpp           | choose dirp project                           |
| dirpl           | list directories in current project           |
| d               | (alias) same as dirpl                         |
| dirpu           | `pushd` current directory and save to project |
| dirpo \<index\> | `popd` the index from dirpl                   |
| dirpos          | `popd` the index from selection               |
| dirpc [name]    | create new project                            |
| dirps           | save current list to selected project         |
| dirpmf          | merge current list from selected project      |
| dirpmt          | merge current list to selected project        |

### `dirp` Menu Reference:

| item # | name               | description                                                                   |
| ---    | ---                | ---                                                                           |
| 1      | load project       | load a project from list (same as `dirpl`)                                    |
| 2      | create projct      | create a new project file (same as `dirpc`)                                   |
| 3      | save to project    | save current project list to another project from list (same as `dirps`)      |
| 4      | delete project     | delete project from list                                                      |
| 5      | list directories   | list directories in current list (same as `diprl`)                            |
| 6      | add directory      | add `cwd` or specified directory to current list (same as `dirpu`)            |
| 7      | delete directory   | remove a directory in current project from a selection list (same as `dirpo`) |
| 8      | clear dirs         | remove all directories from the current list                                  |
| 9      | merge from project | merge directory list from selected project (same as 'dirpmf')                 |
| 10     | merge to project   | merge directory list to selected project (same as dirpmt)                     |
| 11     | show configuration | print current dirp settings                                                   |
| 12     | Quit               | quit the dirp menu                                                            |
| 13     |                    |                                                                               |

## Extended documentation (wiki):

### Configuration:

### Configuration Defaults

### Command line usable functions and aliases:

* 1-30 (numbers)
    * Merely performs a change directory relative to `dirs` indexes (sans the current working directory -because that would be silly)
    * Note: The philosophy behind this is hinted in the use cases. The bash builtin function `dirs -v` provides indexes that can be used by specifying `~<index>` which can be used for copying, moving, etc. So these aliases literally substitute change directory commands that correspond to the `d` function output (which is actually the same thing as `dirs -v` (but colorized) above. so `1<enter>` on the command line is the same as typing `cd ~1` -which corresponds to the first directory listing in the `dirs` directory stack. Some people HATE this idea. Others (me) like it. meh.

### Color Configuration References

Here's some references that might help out if you want to play around with colors and underlines and stuffs:

* [The entire table of ANSI color codes.](https://gist.github.com/chrisopedia/8754917)
* [public-bash-scripts/unix-color-codes.sh at master · ryanoasis/public-bash-scripts](https://github.com/ryanoasis/public-bash-scripts/blob/master/unix-color-codes.sh)
* [shell-color-pallet/color16 at master · yonchu/shell-color-pallet](https://github.com/yonchu/shell-color-pallet/blob/master/color16)
* [Jafrog's dev blog](http://jafrog.com/2013/11/23/colors-in-terminal.html)
* [Shell Colors: colorizing shell scripts ~ Bash Shell Scripting by Examples](http://www.bashguru.com/2010/01/shell-colors-colorizing-shell-scripts.html)

## Future Features:
* Syncronize `pushd` and `popd` operations with dirp (optional).
* Automatically synchronize a project list from a directory file
* Easily synchronize directory groups across systems (via `ssh` or `git`).

## Contributing:

## License:

## Thanks:
