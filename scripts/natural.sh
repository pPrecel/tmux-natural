#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/os-helpers.sh"

main() {
    os-helpers::set_os_icon

    tmux set-option -g status-left " ${os_icon}  #[fg=default]|"
    tmux set-option -g status-right "|  %H:%M  %d-%b-%y"
    tmux set-option -gw window-status-separator "|"
    tmux set-option -gw window-status-format " #I:#W "
    tmux set-option -gw window-status-current-format "#[fg=yellow, bold] #I:#W "
}

main
