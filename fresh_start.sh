#!/bin/bash

dev_path="${HOME}/Dev"

casks=("google-chrome" "clipy" "spectacle" "iterm2" "visual-studio-code" "notion" "sublime-text" "jetbrains-toolbox" "postman" "alfred" "docker")

packages=("git" "node" "python" "openjdk@17" "dockutil" "neovim")

installed=$(brew list --versions)

dock=false

while getopts 'd' OPTION; do
	case "${OPTION}" in
		d)
			echo "cleaning up dock at the end of the script"
			dock=true		
			;;
		*)
			echo "script usage: $0 [-d]" 1>&2
			exit 1
			;;
	esac
done

# Create Dev directory
if [ -d ${dev_path} ] 
then
	echo "Directory ${dev_path} exists." 
else
	mkdir ${dev_path}
	echo "Directory ${dev_path} does not exists. Creation completed."
fi

# Install Brew
which -s brew
if [ $? != 0 ]
then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Installed Brew"
else
	brew update
	echo "Brew exists. Updated Brew."
fi

# Install Brew casks
for cask in "${casks[@]}"
do
	$(echo ${installed} | grep ${cask} &>/dev/null)
	if [ $? != 0 ]
	then
		brew install --cask ${cask} 
	else
		echo "${cask} exists."
	fi
done

# Install Brew packages
for package in "${packages[@]}"
do
	$(echo ${installed} | grep ${package} &>/dev/null)
	if [ $? != 0 ]
	then
		brew install ${package} 
	else
		echo "${package} exists."
	fi
done

# Install Oh My Zsh
if [ -d ${HOME}/.oh-my-zsh ]
then
	echo "Oh My Zsh exists."
else
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo "Installed Oh My Zsh"
fi

# Clean up dock
if [ $dock = true ]
then
	echo "cleaning up dock..."
	dockutil --remove all
	dockutil --add $HOME/Applications/JetBrains\ Toolbox/IntelliJ\ IDEA\ Ultimate.app
	dockutil --add $HOME/Applications/JetBrains\ Toolbox/PyCharm\ Professional.app
	dockutil --add $HOME/Applications/JetBrains\ Toolbox/DataGrip.app
	dockutil --add /Applications/Postman.app
	dockutil --add /Applications/Sublime\ Text.app
	dockutil --add /Applications/Visual\ Studio\ Code.app
	dockutil --add /Applications/Google\ Chrome.app
	dockutil --add /Applications/Notion.app
	dockutil --add /Applications/iTerm.app
fi

echo "++++ Installation completed ++++"

