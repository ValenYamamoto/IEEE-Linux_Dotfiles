# IEEE@UCI Linux Dotfiles

## Overview
- [IEEE@UCI Linux Dotfiles](#ieeeuci-linux-dotfiles)
  - [Overview](#overview)
  - [What is a Dotfile](#what-is-a-dotfile)
  - [.bashrc](#bashrc)
    - [What to put in your .bashrc](#what-to-put-in-your-bashrc)
      - [Aliases](#aliases)
      - [Default Editors](#default-editors)
      - [Custom Prompt](#custom-prompt)
      - [Other setup stuff](#other-setup-stuff)
  - [.vimrc](#vimrc)
    - [What to put in your .vimrc](#what-to-put-in-your-vimrc)
    - [.vim/ftplugin](#vimftplugin)
  - [.tmux.conf](#tmuxconf)
  - [.ssh/](#ssh)
    - [SSH Keys](#ssh-keys)
    - [.ssh/config](#sshconfig)
    - [Troubingshooting](#troubleshooting)
  - [Symlinking Script](#symlinking-script)
    - [What is a Symlink?](#what-is-a-symlink)
    - [Symlink Bash Script](#symlink-bash-script)
  - [Next Steps](#next-steps)
  - [More Resources](#more-resources) 

## What is a Dotfile 
Dotfiles are configuration files for Unix systems, usually with names that start with a
dot (hence dotfiles). 

## .bashrc 

.bashrc runs every time a user logs into a system and every time a new tab/tmux
window is opened. Usually this file
contains all configurations for the terminal, like setting up the environment,
aliasing, coloring, etc. (sometimes people will put each of these in their own
file for organizational purposes)

### What to put in your .bashrc 

#### Aliases 

Aliases are references to other
commands, used like shortcuts for long commands or commands with lots of
options.

Common aliases include appending the *-v* flag to most common commands like cp
and mv.  ```bash alias mv='mv -v' alias cp='cp -v' ```

Aliasing can be very useful for long commands with lots of options you can never
remember ```bash alias memcheck='valgrind --tool=memcheck --leak-check=yes
--show-reachable=yes --num-callers=20 --track-fds=yes' ``` And now instead of
writing *valgrind --tool .... ./myExec* we can just write *memcheck ./myExec*,
which is much shorter and easier to remember.

Sometimes people will spin these off into their own file: consider this if you
have a lot of aliases.

#### Default Editors 

A lot of the time, the default editor is something strange
like nano (who uses nano?), so a good thing to put in your .bashrc is the actual
editing program you want to use. The default editor will be called whenever a
program needs you to make changes to a files, like git commit messages. 

To set the default editor, we set variables EDITOR and VISUAL. Informally,
VISUAL is usually set to full terminal GUI editors and EDITOR is your non-GUI
program, but I usually just use vim, so I set both to vim.  ```bash export
EDITOR=vim export VISUAL=vim ```

#### Custom Prompt 

To customize your prompt, write to the PS1 variable. You can
play with different variables and colors at [this
site](https://scriptim.github.io/bash-prompt-generator/). Take whatever it says
your PS1 should be and add this to your bashrc.  ```bash export PS1='whatever
you got from that website' ```

#### Other setup stuff 

If you have to export anything new to your path, you
would do this here (like libraries and where to find certain executable files).
If you want to 'alias' a few commands together, you can
package them together as a function, which you would write in your .bashrc.

To reload your .bashrc to see your changes, you can run the file ```source
~/.bashrc ```

## .vimrc 

.vimrc is the dotfile configuration file for vim (which is my editor
of choice). You can have a file locally for your account, which is usually
located in your home directory, but there is also a global .vimrc located
somewhere in the /etc folder. This file will run everytime a file is opened in
vim.

### What to put in your .vimrc 

To help with navigation, enabling line numbers is
good.  ```vim set nu ```

The constant thorn in any programmer's side is tabs, so it's a good idea to set
what a tab is. *tabstop* is used to set visually how many spaces a tab is;
*softtabstop* is the number of spaces actually used.  ```vim set tabstop=4 set
softtabstop=4 ``` To have vim automatically indent, we use ```vim filetype
indent on ```

To show matching brackets/parentheses: ```vim set showmatch ```

To have vim autocomplete filenames and show a menu of matches: ```vim set
wildmenu ```

To have vim automatically keep the same indentation when opening a new line:
```autoindent```

And much, much more! You can set color themes and searching preferences and
rebind certain combination of keys, etc.

### .vim/ftplugin

If you want specific commands to run for a particular filetype, put a file with
name ```filetype.vim``` in folder .vim/ftplugin/ and then put in your .vimrc
file the line ```filetype plugin on```.

To tell what kind of file vim considers a particular file, open the file and run
```:set filetype?```.

This can be used to set max line width for markdown or Tex files or set tabs and
spaces for python files

Note on tex files: sometimes .tex files are opened as tex files or plaintex
files. Most of the time, I treat these the same, so I just symlink the tex.vim
to the plaintex.vim file.

## .tmux.conf

.tmux.conf is the dotfile in charge of tmux. This file can be used to rebind
keys and enable mouse control in tmux.

I, in particular, like to rebind the vertical and horizontal split pane commands
to match vim's commands and to rebind keys for the movement between panes.

## .ssh/

.ssh/ directory holds all the information for ssh connections. The directory
contains:
- ssh files/folders
- authorized_hosts: file that holds all recognized public keys
- known_hosts: holds ID of hosts that have connected before
- config file: allows more customization of ssh settings

### SSH Keys

ssh keys are used to sign into other systems and compose of a private key, which
you keep, and a public key, which can be distributed to any number of people.
When a connection is established, the computer you want to connect to will send
a message encoded using the public key and your computer decodes it with the
private key and send it back. If the message is correct, a message is
established.

To create a ssh public/private key pair, use command ```ssh-keygen -t rsa -b
4096```, which creates a ssh key that is 4096 encoded using the RSA scheme. The
public key is called ```id_rsa.pub``` (all public keys end with extension .pub)
and the private key is ```id_rsa```.

To copy the public key to another remote host, use command ```ssh-copy-id -i
[location of public key] [user]@[host]```.

### .ssh/config

This is the configuration file for SSH connections. In this file, you can use
specific identity files for certain host and create shorter names for hosts with
long names.

For example, signing into the ICS servers requires both your ICS password and
for you to type in the very long hostname openlab.ics.uci.edu. Using the config
file, we can shorten this.

```
Host openlab
	HostName openlab.ics.uci.edu
	User vyamamot
	IdentityFile ~/.ssh/ics/id_rsa
```

Now instead of having to type ```ssh vyamamot@openlab.ics.uci.edu```, you can
just type ```ssh openlab```. And if you use ssh-copy-id, then you don't even
need to provide your password.

### Troubleshooting

If anything doesn't seem to be working, check the permissions of any of the
files. Almost all of the files in .ssh require very specific permissions which
if not set correctly, do not work.

## Symlinking Script 

### What is a Symlink?  

Symlinks are symbolic links or a
soft link, which means they are references to other files. Unlike hardlinks,
symlinks point to filenames and not to the original file data, which means if
the original file is deleted, the symlink breaks and will not be able to display
the data. Editing symlinks edits the original file. ```bash ln -s ORIGINAL_FILE LINK_NAME```

Symlinks are useful here for our dotfiles because you can symbolically link your
files to your home directory without having to move them there physically from
where you store them (like a another folder, git repository, etc.). A special
feature of symlinks is that when ```ls -l``` is called, it shows what file it
points to.


### Symlink Bash Script 
If there is a default vimrc or bashrc, for safety's sake, you should
probably copy them somewhere else. Symlinks can't be created if a file with the
same name already exists, so you would need to delete or move the default file
away.

To test whether a file exists and coping : ```bash VIMRC=~/.vimrc if test -f
$VIMRC; then mv $VIMRC ./old_files/ fi BASHRC=~/.bashrc if test -f $BASHRC; then
mv $BASHRC ./old_files/ fi ```

Then we need to symlink our files ```bash ln -sf $1/vimrc $VIMRC ln -sf
$1/bashrc $BASHRC ``` And then we are done!

Remember to use absolute(ish) paths when making symlinks that span different
directories.

## Next Steps

For a more customized setup, consider checking out Ansible, which is a sysadmin
tool for deploying resuable configuration files. Check out Ansible playbooks for
more information; for an example, check out my github below (but really you
could find better literally anywhere else)

## More Resources 

[More Stuff to Put in your
Vimrc](https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/)

[Overview of
Bashrc](https://www.routerhosting.com/knowledge-base/what-is-linux-bashrc-and-how-to-use-it-full-guide/)

[On some other
dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789)

[My not-up-to-date Dotfiles](https://github.com/ValenYamamoto/linux_setup)
