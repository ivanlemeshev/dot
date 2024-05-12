#!/bin/sh

# This option tells the shell to exit immediately if any command exits with a
# non-zero status.
set -e

# Use the configured user if the container has been configured already.
if [ -e /var/run/configured ]; then
  exec sh -c "su - $(head -1 /var/run/configured_user)"
fi

ask_username() {
    username="username"
    printf "What username do you wnat to use? (%s): " "${username}"
    read -r val
    if [ -n "${val}" ]; then
        username="${val}"
    fi
}

ask_uid() {
    userid="1001"
    printf "What user ID do you wnat to use? (%s): " "${userid}"
    read -r val
    if [ -n "${val}" ]; then
        userid="${val}"
    fi
}

ask_group() {
    group="${username}"
    printf "What group name do you wnat to use? (%s): " "${username}"
    read -r val
    if [ -n "${val}" ]; then
        group="${val}"
    fi
}

ask_guid() {
    groupid="1001"
    printf "What group ID do you wnat to use? (%s): " "${groupid}"
    read -r val
    if [ -n "${val}" ]; then
        groupid="${val}"
    fi
}

ask_home_directory() {
    home="/home/${username}"
    printf "What user home directory do you wnat to use? (%s): " "${home}"
    read -r val
    if [ -n "${val}" ]; then
        home="${val}"
    fi
}

ask_shell() {
    shell="/bin/bash"
    printf "What user shell do you wnat to use? (%s): " "${shell}"
    read -r val
    if [ -n "${val}" ]; then
        shell="${val}"
    fi
}

# Ask the user information for the configuration on the first run.
ask_username
ask_uid
ask_group
ask_guid
ask_home_directory
ask_shell

# `-g` sets the group ID for the new group.
groupadd -g "${groupid}" "${group}"

# `-m` tells useradd to create the home directory if it doesn't exist.
# `-s` sets the user's login shell.
# `-d` sets the user's home directory.
# `-u` sets the user's UID.
# `-g` sets the user's primary group ID.
useradd -m -s "${shell}" -d "${home}" -u "${userid}" -g "${groupid}" "${username}"

# The user can run any command as any user without being asked for a password.
echo "${username} ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Change the owner and group of the files or directories at the home directory
# recursively.
chown -R "${username}:${group}" "${home}"

# This file is created to indicate that the container has been configured.
touch /var/run/configured

# Save the configured useusernamer to a file to use it in the next run.
echo "${username}" > /var/run/configured_user

# The su command is used to switch users, and the - option tells su to make the
# environment the same as if the new user had logged in directly.
exec su - "${username}"
