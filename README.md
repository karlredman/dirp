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

## Installation:
See configuration for more details -here's the quick setup/default stuff

Note: It is imperative that this operates via `source <file path>/dirp.bash` from your `.bashrc` (or equivalent). The reason for this is that `dirp`, `pushd`, and `popd` are very strictly "shell scoped". This is one of the main reasons people have so many questions about these utilities, why these utilities are so terribly underused, and why many programmers and admins seek other utilities.

* Note requirements:
    * Bash >=v4.0

1. Clone the project
```
git clone https://github.com/karlredman/dirp.git
```

2. Create a project management directory (small files, per project, that store the absolute paths of files you want to cache)
```
mkdir -p $HOME/dirlists"
```

3. Add the following to your `.bashrc` (or equivalent) file -toward the end...ish
```
source file_path/dirp.bash
```

4. (optionally) Change configurables as needed/desired (see 'Configuration' below)


## Command Usage:

| command         | description                                   |
| ---             | ---                                           |
| dirp            | main menu interface                           |
| dirpp           | choose dirp project                           |
| dirpl           | list directories in current project           |
| d               | (alias enabled by default) same as dirpl      |
| dirpu           | `pushd` current directory and save to project |
| dirpo \<index\> | `popd` the index from dirpl                   |
| dirpos          | `popd` the index from selection               |
| dirps           | save current list to selected project         |

### `dirp` Menu Reference:

| item # | name               | description                                                                   |
| ---    | ---                | ---                                                                           |
| 1      | load project       | load a project from list (same as `dirpl`)                                    |
| 2      | create project     | create a new project file (same as `dirpc`)                                   |
| 3      | save to project    | save current project list to another project from list (same as `dirps`)      |
| 4      | delete project     | delete project from list                                                      |
| 5      | list directories   | list directories in current list (same as `diprl`)                            |
| 6      | add directory      | add `cwd` or specified directory to current list (same as `dirpu`)            |
| 7      | delete directory   | remove a directory in current project from a selection list (same as `dirpo`) |
| 10     | show configuration | print current dirp settings                                                   |
| 11     | Help               | show help message                                                             |
| 12     | Quit               | quit the dirp menu                                                            |

### Extended Configuration:

#### TL;DR

The extended Configuration information below provides information for fine tuning and customization and overriding defaults.

#### Configuration Variables:
* DIRP_LATEST_FILE
    * absolute path of file containing the name of the latest project managed by dirp
    * if set to 'NONE' then dirp_auto returns without reading a file. i.e. no questions or loading of previous project.
        * this is useful if you start tmux/tmuxinator with a `pre: DIRP_LATEST_FILE='NONE';`
* DIRP_PROJECTS_DIR
    * absolute path of the directory repository of project files -that contain directory lists
        * file names are equal to project name
        * files contain directory listings managed by dirp
* DIRP_LIST_COLOR1
    * the first color for project directory file listings
* DIRP_LIST_COLOR2
    * the second color for project directory file listings
* DIRP_EXPERT [true|false]
    * turn off tips and 'Are you sure?' prompts and messages (mostly)
        * honestly I still have stuff like `rm -i <blah>` in the code that is called so it's still kinda idiot (me) proof-ish
* DIRP_USEALIASES_SUITE [true|false]
    * Includes aliases for shortcuts that bypass the menu system -you can turn this off if you want.
    * i.e. adds `alias d=dirp_listColorized`

* DIRP_USEALIASES_DIRNUMS [true|false]
    * This is HIGHLY CONTROVERSIAL for a lot of CLI peoples. Leaving this on (default) creates aliases for numbers 1-30 that will help you navigate directories relative to `dirs`. Look, it might seem simple and trivial but it's kind of a religious thing for some people (not me). I'm not judging and I'm providing the builtin utility if you want to use it. For what it's worth, I do use these aliases.

#### Configuration Defaults

(change as you like -add before `souce <path>/dirp.bash` in your `.bashrc`)

```
DIRP_LATEST_FILE="/tmp/dirp_latest"
DIRP_PROJECTS_DIR="$HOME/dirlists"
DIRP_LIST_COLOR1='\e[0;33m'
DIRP_LIST_COLOR2='\e[0;36m'
DIRP_EXPERT=false
DIRP_USEALIASES_SUITE=true
DIRP_USEALIASES_DIRNUMS=true
```

#### Command line usable functions and aliases:

* 1-30 (numbers)
    * Merely performs a change directory relative to `dirs` indexes (sans the current working directory -because that would be silly)
    * Note: The philosophy behind this is hinted in the use cases. The bash builtin function `dirs -v` provides indexes that can be used by specifying `~<index>` which can be used for copying, moving, etc. So these aliases literally substitute change directory commands that correspond to the `d` function output (which is actually the same thing as `dirs -v` (but colorized) above. so `1<enter>` on the command line is the same as typing `cd ~1` -which corresponds to the first directory listing in the `dirs` directory stack. Some people HATE this idea. Others (me) like it. meh.

#### Color Configuration References

Here's some references that might help out if you want to play around with colors and underlines and stuffs:

* [The entire table of ANSI color codes.](https://gist.github.com/chrisopedia/8754917)
* [public-bash-scripts/unix-color-codes.sh at master · ryanoasis/public-bash-scripts](https://github.com/ryanoasis/public-bash-scripts/blob/master/unix-color-codes.sh)
* [shell-color-pallet/color16 at master · yonchu/shell-color-pallet](https://github.com/yonchu/shell-color-pallet/blob/master/color16)
* [Jafrog's dev blog](http://jafrog.com/2013/11/23/colors-in-terminal.html)
* [Shell Colors: colorizing shell scripts ~ Bash Shell Scripting by Examples](http://www.bashguru.com/2010/01/shell-colors-colorizing-shell-scripts.html)

## Contributing:
Please read: [dirp/CONTRIBUTING.md at master · karlredman/dirp](https://github.com/karlredman/dirp/blob/master/CONTRIBUTING.md)

## License:
This project is hereby copy written by Karl N. Redman (November 29, 2017). Any use of this intellectual property is permitted insofar as such usage conforms to the MIT license included within the project. All rights reserved. Please refer to: [dirp/LICENSE at master · karlredman/dirp](https://github.com/karlredman/dirp/blob/master/LICENSE)
