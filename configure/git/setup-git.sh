#!/bin/bash

echo "--- Configuring git"

ask_default_git_branch() {
    default_git_branch="main"
    printf "What default git branch do you wnat to use? (%s): " "${default_git_branch}"
    read -r val
    if [[ -n "${val}" ]]; then
        default_git_branch="${val}"
    fi
}

ask_git_email() {
    git_email="vanlmshv@gmail.com"
    printf "What git email do you wnat to use? (%s): " "${git_email}"
    read -r val
    if [[ -n "${val}" ]]; then
        git_email="${val}"
    fi
}

ask_git_name() {
    git_name="Ivan Lemeshev"
    printf "What git name do you wnat to use? (%s): " "${git_name}"
    read -r val
    if [[ -n "${val}" ]]; then
        git_name="${val}"
    fi
}

ask_default_git_branch
git config --global init.defaultBranch "${default_git_branch}"

ask_git_email
git config --global user.email "${git_email}"

ask_git_name
git config --global user.name "${git_name}"

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

echo "--- Current git config"
git config --list
