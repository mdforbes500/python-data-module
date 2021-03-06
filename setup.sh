#!/bin/bash

confirm_python () {
    echo "Confirming Python 3 installation..."
    if [[ -n $(python3.8 --version | grep "Python 3.8") ]]
    then
        echo "$(python3.8 --version) is installed"
    else
        echo "Python 3.8 did not install correctly"
        exit 2
    fi
}

confirm_pip () {
    echo "Confirming PIP is installed..."
    if [[ -n $(python3.8 -m pip -V | grep "python 3.8") ]]
    then
        echo "$(python3.8 -m pip -V) is installed"
    else
        echo "Pip for Python 3.8 did not install correctly"
        exit 2
    fi
}

linux_python_install () {
    if [[ -n $(cat /etc/os-release | grep debian) ]]
    then
        sudo apt-get update -y
        sudo apt-get install python3.8 -y
    else
        sudo yum -y update
        sudo yum install python3.8 -y
    fi
}

install_python () {
    case "$OSTYPE" in
        solaris*) 
            echo -e "FAILURE: Detecting unsupported operating system... quitting." 
            exit 1 ;;
        darwin*)  
            echo "Detecting Mac OSX operating system..." 
            echo "Installing XCode Command Line Utilities..."
            sudo xcode-select --install
            echo "Installing Homebrew Package Manager..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            echo "export PATH=\"/usr/local/opt/python/libexec/bin:$PATH\""
            echo "Installing Python 3.8 using Homebrew..."
            brew install python@3.8
            confirm_python
            confirm_pip
            ;; 
        linux*)   
            echo "Detecting Linux-based operating system..." 
            linux_python_install
            confirm_python
            confirm_pip
            ;;
        bsd*)     
            echo "FAILURE: Detecting unsupported operating system... quitting."
            exit 1 ;;
        msys*)    
            echo "FAILURE Detecting unsupported operating system... quitting" 
            exit 1 ;;
        *)        
            echo "FAILURE Detecting unsupported operating system: $OSTYPE... quitting."
            exit 1 ;;
    esac
}

create_venv () {
    echo "Settting up virtual environment..."
    

    case "$OSTYPE" in
        solaris*) 
            echo "FAILURE: Detecting unsupported operating system... quitting."
            exit 1 ;;
        darwin*) 
            python3.8 -m venv .env
            source .env/bin/activate ;;
        linux*) 
            sudo apt-get install python3.8-venv -y
            python3.8 -m venv .env
            source .env/bin/activate ;;
        bsd*) 
            echo "FAILURE: Detecting unsupported operating system... quitting."
            exit 1 ;;
        msys*) 
            echo "FAILURE: Detecting unsupported operating system... quitting."
            exit 1 ;;
        *)  
            echo "FAILURE: Detecting unsupported operating system... quitting."
            exit 1 ;;
    esac

    echo "Installing required packages..."
    python3.8 -m pip install -r requirements.txt
}

main () {
    if [[ -n $(python3.8 --version | grep "Python 3.8") && -n $(python3.8 -m pip -V | grep "python 3.8") ]]
    then
        echo "$(python3.8 --version) is installed"
        echo "$(python3.8 -m pip -V) is installed"
    else
        echo "Python 3.8 not detected"
        read -n1 -p "Install Python 3.8? [Y/n]: " input
        case $input in
            y|Y) 
                echo -e "\nInstalling Python 3.8"
                install_python ;;
            n|N) 
                echo -e "\nExiting..."
                exit 0 
                ;;
            *) 
                echo -e  "Don't know"
                exit 0 
                ;;
        esac
    fi

    create_venv
}

main