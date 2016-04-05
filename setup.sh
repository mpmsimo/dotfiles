#!/bin/bash
#setup.sh
#Date created; 04/04/2016
#Author: mpmsimo

ubuntu_install() {
    # Install Ubuntu development packages
	echo "Ubuntu or apt based systems"
	sudo apt-get update
	sudo apt-get install python-dev python-pip vim wget -y

	# Install zsh from package manger
	#echo "Install zsh package"
	# sudo yum install zsh
	#sudo apt-get install zsh -y
}

centos_install() {
    # Install CentOS development packages
	echo "CentOS or yum based based systems"
	sudo yum update
    sudo yum groupinstall "Development tools" -y
    yum install python-dev vim wget
    yum install zlib-devel bzip2-devel openssl-devel ncurses-devel -y
    yum install libxml2-devel libxslt-devel sqlite sqlite-devel  # -y 
    #yum -y install mysql-devel  # req'd to use MySQL with python('mysql-python' package)
}

install_zsh(){
    # Install ZSH
    ZSH_V="5.2"
    ZSH_URL="www.zsh.org/pub/zsh-$ZSH_V.tar.gz"
    cd ~
    wget $ZSH_URL
    tar zxvf "zsh-$ZSH_V.tar.gz"
    cd ~/"zsh-$ZSH_V"
    ./configure --prefix=/usr/local 
    make && make altinstall

    # Install Oh My ZSH
	echo "Installing Oh My ZSH!"
	cd ~ sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	echo "Making ZSH the default shell" 
	chsh -s "$(which zsh)" # Make ZSH default shell
	echo "Current shell is: $SHELL"
	echo "Zsh version is $(zsh --version)." # Check verison
    echo ""
}

install_dotfiles(){
    # Copy dotfiles to home directory
	echo "Setting default text editor to vim"
	export VISUAL=vim
	export EDITOR="$VISUAL"

	for file in .vimrc .zshrc .gitconfig; #tmux.conf
	do 	
		echo "Moving "$file" to home directory"
		cp $HOME/dotfiles/$file $HOME
	done

	echo "Moving .vim to home directory"
	cp -r $HOME/dotfiles/.vim $HOME
}

install_pip_packages(){
    # Install Python packages 
	cd ~
	virtualenv env
	source ~/env/bin/activate
	pip install powerline-status
}

install_python(){
    PY2_V="2.7.11"
    PY3_V="3.4.4"
    while true
    do
        echo "Which version of Python would you like to install?"
        echo "1. $PY2_V"
        echo "2. $PY3_V"
        echo "0. Quit" 

        read -p "Which option would you like to select? > " version 
        case $version in
            1 ) PY_V=$PY2_V; break;; # Install Python 2.7.11 - Last updated: 2015-12-05
            2 ) PY_V=$PY3_V; break;; # Install Python 3.4.4 - Last updated: 2015-12-21
            0 ) break;;
            * ) echo ""; echo "Please choose a valid option";;
        esac
    done
    PY_URL="https://www.python.org/ftp/python/$PY_V/Python-$PY_V.tgz"
    echo ""; echo "Installing python $PY_V".
    cd ~
    wget --no-check-certificate $PY_URL
    tar zxvf "Python-"$PY_V".tgz"
    cd ~/"Python-$PY_V"
    ./configure --prefix=/usr/local 
    make && make altinstall
}

if [[ $OSTYPE == 'linux-gnu' ]]
	then
		if [[ $(grep -i "id=ubuntu" /etc/*release) == *"ubuntu"* ]]
		then
            echo "pass"
			#ubuntu_install	
		elif [[ $(grep -i "id=centos" /etc/*release) == *"centos"* ]]
		then
			echo "I am CentOS."	
		fi
	echo "Packages have been installed."
elif [[ $OSTYPE == 'darwin*' ]]
then
	echo "I'm a Mac."
else
	echo "Operating system "$OSTYPE" is not supported."
fi

install_zsh
install_dotfiles
#install_pip_packages
#install_python
