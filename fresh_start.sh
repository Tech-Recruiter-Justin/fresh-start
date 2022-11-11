#!/bin/bash

dev_path="${HOME}/Dev"
casks=("google-chrome" "clipy" "spectacle" "iterm2" "visual-studio-code" "notion" "sublime-text" "jetbrains-toolbox" "postman" "alfred" "docker" "flutter" "android-studio")
packages=("git" "node" "python" "openjdk@17" "dockutil" "neovim")
installed=$(brew list --versions)
dock=false
upgrade=false

while getopts 'du' OPTION; do
	case "${OPTION}" in
		d)
			echo "dock clean up: enabled" 
			dock=true		
			;;
		u)
			echo "brew upgrade: enabled"
			upgrade=true		
			;;

		*)
			echo "script usage: $0 [-d] [-u]" 1>&2
			echo "[-d] enables dock clean up"
			echo "[-u] enables brew upgrade"
			exit 1
			;;
	esac
done

create_dev_dir() {
	if [ -d ${dev_path} ] 
	then
		echo "Directory ${dev_path} exists." 
	else
		mkdir ${dev_path}
		echo "Directory ${dev_path} does not exists. Creation completed."
	fi
}

install_and_update_brew() {
	which -s brew
	if [ $? != 0 ]
	then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo "Installed Brew"
	else
		brew update
		echo "Brew exists. Updated Brew."
	fi
}

install_casks() {
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
}

install_packages() {
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
}

install_omz() {
	if [ -d ${HOME}/.oh-my-zsh ]
	then
		echo "Oh My Zsh exists."
	else
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		echo "Installed Oh My Zsh"
	fi
}

clean_up_dock() {
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
}

upgrade_brew() {
	if [ $upgrade = true ]
	then
		echo "upgrading brew packages and casks..."
		brew upgrade
	fi
}

# Main script
create_dev_dir
install_and_update_brew
install_casks
install_packages
install_omz
clean_up_dock
upgrade_brew
echo "++++ Installation completed ++++"

