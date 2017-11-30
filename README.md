# Project: dirp

A Bash shell native dirs/pushd/popd manager.

Author: [Karl N. Redman](https://karlredman.github.io/)

dirp is a bash script meant to be sourced in your .bashrc file to help manage the `dirs`, `pushd`, `popd` builtin functions of bash shell. If ever you wanted to harness the power of dirs/pushd/popd than this is a good place to start. While there isn't much here in the way of originality you may find this tool useful because of it's amalgamation of utility. Let's face it, dirs/pushd/popd is powerful, we all know it, but it's so darn hard to make it work for us. Hopefully this project will help. You are a command line warrior. Now take charge and control your contextual working directory space too!

## Features:
* List and select directories managed by `dirs` in alternating colors
* Fancy CLI Menu driven interface (via bash select)
* Easily switch between directory groups (i.e. projects)
* Automatically sorts directory listings
    * version sensitive
    * alphanumeric
* Handles directory names that use spaces
* Create and delete directory groups easily
* Colors and application behavior managed by environment variables (if desired)
* New logins automatically load the latest project directories (once setup)

## Cool Screenshots!
* TODO: coming soon!


## Installation:

See configuration for more details -here's the quick setup/default stuff

Note: It is imperative that this operates via `source <file path>/dirp.bash` from your `.bashrc`. The reason for this is that `dirp`, `pushd`, and `popd` are very strictly "shell scoped". This is one of the main reasons people have so many questions about these utilities, why these utilities are so terribly underused, and why many programmers and admins seek other utilities (that IMHO are usually over compensating for 'something').

1. Clone the project
2. Create a project management directory (small files, per project, that store the absolute paths of files you want to cache)
```
mkdir -p $HOME/dirlists"
```

3. Add the following to your `.bashrc` (or equivilent) file -toward the end...ish
```
source file_path/dirp.bash
```

4. (optionally) Add the following to the very end of your `.bashrc` file for automatic project loading (see use cases below).
```
## set dirs to recent project -this is optional but recommended and fun
dirp_auto
```

5. (optionally) Change configurables as needed/desired (see 'Configuration' below)
6. Profit.

## Configuration:

All configuration variables can be overridden via environment before sourcing the `dirp.bash` file. These are my defaults and my personal configuration.

### Configuration Variables:
* DIRP_LATEST_FILE
    * absolute path of file containing the name of the latest project managed by dirp
* DIRP_PROJECTS_DIR
    * absolute path of the directory repository of project files -that contain directory lists
        * file names are equal to project name
        * files contain directory listings managed by dirp
* DIRP_LIST_COLOR1
    * the first color for project directory file listings
* DIRP_LIST_COLOR2
    * the second color for project directory file listings
* DIRP_EXPERT
    * turn off tips and 'omg wtf are you doing?!' prompts and messages (mostly)
        * honestly I still have stuff like `rm -i <blah>` in the code that is called so it's still kinda idiot (me) proof-ish
* DIRP_USEALIASES_SUITE
    * Includes several aliases for shortcuts that bypass the menu system -you can turn this off if you want

* DIRP_USEALIASES_DIRNUMS
    * This is HIGHLY CONTROVERSIAL for a lot of CLI peoples. Leaving this on (default) creates aliases for numbers 1-30 that will help you navigate directories relative to `dirs`. Look, it might seem simple and trivial but it's kind of a religious thing for some people (not me). I'm not judging and I'm providing the builtin utility if you want to use it. For what it's worth, I do use these aliases religiously.

### Configuration Defaults

(change as you like -probably best before `souce <path>/dirp.bash` in your `.bashrc`)

```
DIRP_LATEST_FILE="/tmp/dirp_latest"
DIRP_PROJECTS_DIR="$HOME/dirlists"
DIRP_LIST_COLOR1='\e[0;33m'
DIRP_LIST_COLOR2='\e[0;36m'
DIRP_EXPERT=false
DIRP_USEALIASES_SUITE=true
DIRP_USEALIASES_DIRNUMS=true
```

#### Color Configuration References

Here's some references that might help out if you want to play around with colors and underlines and stuffs:

* [The entire table of ANSI color codes.](https://gist.github.com/chrisopedia/8754917)
* [public-bash-scripts/unix-color-codes.sh at master · ryanoasis/public-bash-scripts](https://github.com/ryanoasis/public-bash-scripts/blob/master/unix-color-codes.sh)
* [shell-color-pallet/color16 at master · yonchu/shell-color-pallet](https://github.com/yonchu/shell-color-pallet/blob/master/color16)
* [Jafrog's dev blog](http://jafrog.com/2013/11/23/colors-in-terminal.html)
* [Shell Colors: colorizing shell scripts ~ Bash Shell Scripting by Examples](http://www.bashguru.com/2010/01/shell-colors-colorizing-shell-scripts.html)


## Use Cases & References:
* TODO: coming soon!
    * sorry I ran out of time to formulate this properly this week. I'll try to update this in the next few days.

## Command line usable functions and aliases:

* dirp
    * Display interactive management menu
    * example
    ```
    karl@karl-samsung ~ $ dirp
    1) load project		  3) save to project    5) list directories	    7) delete directory	9) append from project  11) Quit
    2) create project	  4) delete project	    6) add directory	    8) clear dirs	    10) show configuration
    #? 1
    Load Project File:
    1) testing
    2) testproject
    3) timetrap_tui
    4) Quit
    #? 1
    testing:
     1  ~/Projects/github/Timetrap_TUI
     2  ~/Projects/github/node-timetrap_wraplib
     3  ~/Projects/timetrap_tui/dev_cycles/phase2.0
     4  ~/Projects/timetrap_tui/dev_cycles/phase2.1
     5  ~/Scratch/blessed-contrib/lib/widget
     6  ~/Scratch/blessed/lib/widgets
     7  ~/Scratch/blessed/test
    done. Note: this is the same as 'dirp_appendProject project_name true; dirp_listColorized'
    karl@karl-samsung ~ $
    ```

* pd
    * `pushd` current directory

* d
    * List current project directories (colorized)
    * example
    ```
    karl@karl-samsung ~ $ d
    testing:
     1  ~/Projects/github/Timetrap_TUI
     2  ~/Projects/github/node-timetrap_wraplib
     3  ~/Projects/timetrap_tui/dev_cycles/phase2.0
     4  ~/Projects/timetrap_tui/dev_cycles/phase2.1
     5  ~/Scratch/blessed-contrib/lib/widget
     6  ~/Scratch/blessed/lib/widgets
     7  ~/Scratch/blessed/test
    karl@karl-samsung ~ $ 3
    karl@karl-samsung ~/Projects/timetrap_tui/dev_cycles/phase2.0 $
    ```

* 1-30 (numbers)
    * Merely performs a change directory relative to `dirs` indexes (sans the current working directory -because that would be silly)
    * Note: The philosophy behind this is hinted in the use cases. The bash builtin function `dirs -v` provides indexes that can be used by specifying `~<index>` which can be used for copying, moving, etc. So these aliases literally substitute change directory commands that correspond to the `d` function output (which is actually the same thing as `dirs -v` (but colorized) above. so `1<enter>` on the command line is the same as typing `cd ~1` -which corresponds to the first directory listing in the `dirs` directory stack. Some people HATE this idea. Others (me) like it. meh.

* dirpl
	* load project from project selection
    * example:
     ```
    karl@karl-samsung ~ $ dirpl
    Load Project File:
    1) testing
    2) testproject
    3) timetrap_tui
    4) Quit
    #? 1
    karl@karl-samsung ~ $ d
    testing:
     1  ~/Projects/github/Timetrap_TUI
     2  ~/Projects/github/node-timetrap_wraplib
     3  ~/Projects/timetrap_tui/dev_cycles/phase2.0
     4  ~/Projects/timetrap_tui/dev_cycles/phase2.1
     5  ~/Scratch/blessed-contrib/lib/widget
     6  ~/Scratch/blessed/lib/widgets
     7  ~/Scratch/blessed/test
     ```

* dirps
	* save dirs list to project selection
    * example:
    ```
    karl@karl-samsung ~ $ d
    testing:
     1  ~/Projects/github/Timetrap_TUI
     2  ~/Projects/github/node-timetrap_wraplib
     3  ~/Projects/timetrap_tui/dev_cycles/phase2.0
     4  ~/Projects/timetrap_tui/dev_cycles/phase2.1
     5  ~/Scratch/blessed-contrib/lib/widget
     6  ~/Scratch/blessed/lib/widgets
     7  ~/Scratch/blessed/test
    karl@karl-samsung ~ $ dirps
    Save dirs list to Project File:
    1) testing
    2) testproject
    3) timetrap_tui
    4) Quit
    #? 1
    Do you wish to overwrite /home/karl/dirlists/testing?
    1) Yes
    2) No
    #? 1
    Overwrote /home/karl/dirlists/testing
    karl@karl-samsung ~ $
    ```

## API Functions

* dirp_auto
    * Meant to be invoked at login/terminal-open
    * Attempts to load the most recent project `dirs` configuration
        * if none found, prompt with a menu
	* argument (optional, overrides DIRP_LATEST_FILE):  project name

* dirp_menu_main
	* the dirp menu -basically the menu side of all of the functions herein

* dirp_saveProject
    * Save a dirs list for a given project
    * arguments:
        * $1: name of project

* dirp_appendProject
    * append dirs list from file (one absolute path per line)
    * arguments
        * `$1`: project name
        * `$2`: clear dirs [true|false]
    * note: if $2==true, update DIRP_LATEST_FILE

* dirp_deleteProject
    * delete project from selection

* dirp_listColorized
	* list items in `dirs -v` with alternating colors

* dirp_menu_projects_cb
	* display message, list projects, and call callback

* dirp_showConfig
	* show configuration settings

* dirp_msg
    * echo messages relative to 'expert mode' for printing hints and wtf stuffs

## Further Notes:

Comments and pointers and criticisms and opinions are VERY WELCOME. Please do say something if you have suggestions. Otherwise I'm likely not going to do much with this project. I've been using most of these functions for nearly a decade as it is -shame on me for not sharing. I do hope some of this stuff helps someone out there somewhere.

Also, please take no offense at my seemingly lighthearted treatment of this material. I really do take this stuff very seriously -it's my lifeblood and keeps me sane. Also I've written nearly 400 lines of code here with over 100 lines of comments as a token of my sincerity. The goofy way that I've presented some of this material is a reflection of my experience with like minded persons who, for the 20 years I've been in this industry, constantly seek out better ways of doing things and are driven absolutely crazy when tools like dirs/pushd/popd aren't more widely used. My version of levity here is a reflection of these frustrations and insights and ah! ha! moments when you are given a tool but never given any/much information on how to use it. Hey, versions of directory stacks have been around for longer than I've been in this industry, and I'm telling you... just type `man dirs` in your linux terminal right now -90% of all unix's (I'm guessing) have zero documentation. Look this stuff up? Lots of questions and not a lot of answers about actually managing your environment with these awesome tools. So with all due respect to the implementers, it's kind of a sad joke these tools were never leveraged as they could have been. -my 2 cents.

## Licence:
This project is hereby copy written by Karl N. Redman (November 29, 2017). Any use of this intellectual property is permitted insofar as such usage conforms to the MIT license included within the project. All rights reserved.
