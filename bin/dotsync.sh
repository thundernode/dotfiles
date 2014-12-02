#!/bin/bash
dotrepo="${HOME}/.dotfiles"

if [ ! -e $dotrepo ]; then
  if git clone --recursive git@github.com:thundernode/dotfiles.git $dotrepo ; then
    echo "Cloned into ${dotrepo}"
  elif git clone --recursive https://github.com/thundernode/dotfiles.git $dotrepo ; then
    echo -e "\e[31mFailed to clone via ssh.\e[0m Cloned via https instead."
  else
    echo -e "\e[31mFailed to clone.\e[0m" && exit 1
  fi
else
  cd $dotrepo
  git pull
  git submodule update --init --recursive
fi


dotfiles=`find $dotrepo -maxdepth 1 -type f \( ! -iname ".git*" \) -printf "%f\n"`
dotfolders=`find $dotrepo -maxdepth 1 -type d \( ! -iname ".git*" ! -iname "." ! -iname ".dotfiles" \) -printf "%f\n"`

for file in $dotfiles; do
  if [ -L $HOME/$file ]; then
    ln -nfs $dotrepo/$file $HOME/$file
  elif [ -e $HOME/$file ]; then
    mv $HOME/$file $HOME/$file.bk
    ln -nfs $dotrepo/$file $HOME/$file
  else
    ln -nfs $dotrepo/$file $HOME/$file
  fi
done

for folder in $dotfolders; do
  if [ ! -e $HOME/$folder ]; then
    mkdir $HOME/$folder
  fi
done


for folder in $dotfolders; do
  dotfolderfiles=`find $dotrepo/$folder -maxdepth 1 \(  ! -iname "$folder" \) -printf "%f\n"`
  for filefolders in $dotfolderfiles; do
    if [ -L $HOME/$folder/$filefolders ]; then
      ln -nfs $dotrepo/$folder/$filefolders $HOME/$folder/$filefolders
    elif [ -e $HOME/$folder/$filefolders ]; then
      mv $HOME/$folder/$filefolders $HOME/$folder/$filefolders.bk
      ln -nfs $dotrepo/$folder/$filefolders $HOME/$folder/$filefolders
    else
      ln -nfs $dotrepo/$folder/$filefolders $HOME/$folder/$filefolders
    fi
  done
done
