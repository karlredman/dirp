# dirp Project FAQ


# TODO Items:

## Why do project files sometimes contain missing directories or broken links?:

It's possible that a link might be broken or a directory removed temporarily while working on the command line. If the path has been saved to the project file then there is no assumption about the future intent of those paths. d() doesn't display these broken links and missing directories in the list but the paths will remain in the file unless explicitly removed or dirp_cull() is called by the user.

## Why doesn't d() print broken links or missing directories?:

Because it's annoying. Set the variable `DIRP_LIST_ALL_ALWAYS` or call `D()` / `dirp_listColorized() all` to see the full list relative to `dirs`. Note: the final list is subject to `dirs` acceptance of the path.
