#!/bin/bash
if [ ! -d old_files ]; then
	mkdir old_files
	if [ $? -ne 0 ]; then
		echo "Could not make old_files directory"
		exit 1
	fi
fi

VIMRC=~/.vimrc
if test -f $VIMRC; then
	mv -v $VIMRC ./old_files/
fi

BASHRC=~/.bashrc
if test -f $BASHRC; then
	mv -v $BASHRC ./old_files/
fi


ln -sf $1/vimrc $VIMRC
if [ $? -ne 0 ]; then
	echo "Could not symlink vimrc"
fi

ln -sf $1/bashrc $BASHRC
if [ $? -ne 0 ]; then
	echo "Could not symlink bashrc"
fi
