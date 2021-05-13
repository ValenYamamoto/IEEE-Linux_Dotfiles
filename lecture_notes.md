# IEEE@UCI Linux Dotfiles

## What is a Dotfile
Dotfiles are configuration files for Unix systems, usually with names that start with a dot (hence dotfiles). 

## .bashrc
.bashrc runs every time a user logs into a system. Usually this file contains all configurations for the terminal, like setting up the environment, aliasing, coloring, etc. (sometimes people will put each of these in their own file for organizational purposes)

### What to put in your .bashrc
#### Aliases
Aliases are references to other commands, used like shortcuts for long commands or commands with lots of options.

Common aliases include appending the *-v* flag to most common commands like cp and mv.
```bash
alias mv='mv -v'
alias cp='cp -v'
```

Aliasing can be very useful for long commands with lots of options you can never remember
```bash 
alias memcheck='valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes'
```
And now instead of writing *valgrind --tool .... ./myExec* we can just write *memcheck ./myExec*, which is much shorter and easier to remember.

#### Default Editors
A lot of the time, the default editor is something strange like nano (who uses nano?), so a good thing to put in your .bashrc is the actual editing program you want to use.

To set the default editor, we set variables EDITOR and VISUAL. Informally, VISUAL is usually set to full terminal GUI editors and EDITOR is your non-GUI program, but I usually just use vim, so I set both to vim.
```bash
export EDITOR=vim
export VISUAL=vim
```

#### Custom Prompt
To customize your prompt, write to the PS1 variable. You can play with different variables and colors at [this site](https://scriptim.github.io/bash-prompt-generator/). Take whatever it says your PS1 should be and add this to your bashrc.
```bash
export PS1='whatever you got from that website'
```

#### Other setup stuff
If you have to export anything new to your path, you would do this here. If you want to 'alias' a few commands together, you can package them together as a function, which you would write in your .bashrc.

To reload your .bashrc to see your changes, you can run the file
```bash
~/.bashrc
```

## .vimrc
.vimrc is the dotfile configuration file for vim (which is my editor of choice). You can have a file locally for your account, which is usually located in your home directory, but there is also a global .vimrc located somewhere in the /etc folder.

### What to put in your .vimrc
To help with navigation, enabling line numbers is good.
```vim
set nu
```

The constant thorn in any programmer's side is tabs, so it's a good idea to set what a tab is. *tabstop* is used to set visually how many spaces a tab is; *softtabstop* is the number of spaces actually used.
```vim
set tabstop=4
set softtabstop=4
```
To have vim automatically indent, we use
```vim
filetype indent on
```

To show matching brackets/parentheses:
```vim
set showmatch
```

To have vim autocomplete filenames and show a menu of matches:
```vim
set wildmenu
```

And much, much more! You can set color themes and searching preferences and rebind certain combination of keys, etc.

## Symlinking Script
### What is a Symlink?
Symlinks are symbolic links or a soft link, which means they are references to other files. Unlike hardlinks, there is not a copy of the file made. Editing symlinks edits the original file.
```bash
ln -s ORIGINAL_FILE LINK_NAME
```

Symlinks are useful here for our dotfiles because you can symbolically link your files to your home directory without having to move them there physically from where you store them (like a another folder, git repository, etc.)
### Symlink Bash Script
If there is a default vimrc or bashrc, for safety's sake, you should probably copy them somewhere else. Symlinks can't be created if a file with the same name already exists, so you would need to delete or move the default file away.

To test whether a file exists and coping :
```bash
VIMRC=~/.vimrc
if test -f $VIMRC; then
    mv $VIMRC ./old_files/
fi
BASHRC=~/.bashrc
if test -f $BASHRC; then
    mv $BASHRC ./old_files/
fi
```

Then we need to symlink our files
```bash
ln -s dotfiles/vimrc $VIMRC
ln -s dotfiles/bashrc $BASHRC
```
And then we are done!