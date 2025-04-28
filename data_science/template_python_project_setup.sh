#!/usr/bin/env bash
################################################################################
# Python Project Bootstrap Script
#
# Author: Aluci
# Created: 2025-04
#
# Description:
#   Initialises (bootstraps) a Python project directory by
#       - Installing Miniconda (if missing)
#       - Creating & activating a Python 3.10 Conda environment
#       - Installing Poetry with pip
#       - Installing project dependencies with Poetry
#       - Installing git-pre-commit hooks
#
# Usage:
#   ./ds_project_setup.sh [-h] [-d]
#       -h | --help   Show help and exit
#       -d | --debug  Verbose mode - show each command
#
# NOTE: run as a normal user (NOT root). Internet access is required.
################################################################################

set -euo pipefail

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

# Help message
dhelp() {
    cat <<EOF
Usage: $0 [OPTIONS]

Description :
    Initialises (bootstraps) a Python project directory by
        - Installing Miniconda (if missing)
        - Creating & activating a Python 3.10 Conda environment
        - Installing Poetry with pip
        - Installing project dependencies with Poetry
        - Installing git-pre-commit hooks

Options:
    -h, --help    Show this help and exit
    -d, --debug   Verbose mode - show each command

Examples:
    $0 -h
    $0 -d
EOF
}

# Refuse to run as root
check_not_root() {
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}Do NOT run this script as root - use an unprivileged account.${RESET}"
        exit 2
    fi
}

# Option parsing
OPTS=$(getopt -o hd --long help,debug -n 'ds_project_setup.sh' -- "$@") || {
    dhelp
    exit 0
}
eval set -- "$OPTS"

DEBUG=false
while true; do
    case "$1" in
    -h | --help)
        dhelp
        exit 0
        ;;
    -d | --debug)
        DEBUG=true
        shift
        ;;
    --)
        shift
        break
        ;;
    esac
done

# Helper: run quietly unless in debug mode
quiet_run() {
    if [ "$DEBUG" = true ]; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi
}

[ "$DEBUG" = true ] && set -x

# Miniconda
install_miniconda() {
    if quiet_run command -v conda; then
        echo -e "${GREEN}✓ Miniconda already installed - skipping${RESET}"
        return
    fi

    echo "Installing Miniconda …"
    mkdir -p "$"$HOME"/miniconda3"
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
        -O "$"$HOME"/miniconda3/miniconda.sh"
    bash "$"$HOME"/miniconda3/miniconda.sh" -b -u -p "$"$HOME"/miniconda3"
    rm -f "$"$HOME"/miniconda3/miniconda.sh"

    # Make conda available now and in future shells
    eval "$("$"$HOME"/miniconda3/bin/conda" shell.bash hook)"
    quiet_run "$"$HOME"/miniconda3/bin/conda" init bash
}

# Conda environment
create_conda_env() {
    local env="ds_env"
    if conda env list | awk '{print $1}' | grep -qx "$env"; then
        echo -e "${GREEN}✓ Conda env '$env' already exists - skipping creation${RESET}"
    else
        echo "Creating Conda env '$env' with Python 3.10 …"
        quiet_run conda create -y -n "$env" python=3.10
    fi

    # Activate for the rest of the script
    eval "$(conda shell.bash hook)"
    conda activate "$env"
}

# Poetry
install_poetry() {
    if quiet_run command -v poetry; then
        echo -e "${GREEN}✓ Poetry already installed in env - skipping${RESET}"
    else
        echo "Installing Poetry (pip) …"
        quiet_run pip install poetry
    fi
}

# Project dependencies
run_poetry_install() {
    if [ -f "pyproject.toml" ]; then
        echo "Installing project dependencies via Poetry …"
        quiet_run poetry install
    else
        echo -e "${RED}Error: no pyproject.toml found in $(pwd).${RESET}"
        exit 4
    fi
}

# pre-commit hooks
setup_pre_commit() {
    if quiet_run command -v pre-commit; then
        echo "Installing pre-commit hooks …"
        quiet_run pre-commit install || true
    else
        echo -e "${RED}pre-commit not available - is it in pyproject.toml?${RESET}"
    fi
}

# Main
check_not_root
install_miniconda
create_conda_env
install_poetry
run_poetry_install
setup_pre_commit

echo -e "${GREEN}✔ Project successfully initialised!${RESET}"
echo
echo "# ----------------------------------------------------------------------"
echo "# Need a library that isn't yet in pyproject.toml?"
echo "# Activate the env and run:  pip install <package>"
echo "# ----------------------------------------------------------------------"

exit 0
