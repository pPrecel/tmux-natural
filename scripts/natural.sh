#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/os-helpers.sh"

main() {
    local clock_icon=""
    local calendar_icon=""
    local search_icon=""
    #local bell_icon=""
    os-helpers::set_os_icon

    tmux set-option -g status-left " ${os_icon}  #[fg=default]| "
    tmux set-option -ag status-right "| $clock_icon %H:%M $calendar_icon %d-%b-%y"
    tmux set-option -gw window-status-separator " | "
    tmux set-option -gw window-status-format "#{?window_zoomed_flag,$search_icon ,} #I:#W"
    tmux set-option -gw window-status-current-format "#[fg=yellow, bold]#{?window_zoomed_flag,$search_icon ,} #I:#W"
}

main
