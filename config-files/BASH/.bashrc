#
# ~/.bashrc
#

# exec fish

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias lsa='ls -a'
alias q='fish'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
