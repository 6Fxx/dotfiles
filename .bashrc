 #~/.bashrc

# Cle API Perplexity
#export PERPLEXITY_API_KEY=pplx-

# Force le terminal couleur (evite les soucis avec Ghostty)
export TERM=xterm-256color

# Definition de la langue
export LANG=fr_FR.UTF-8
#export LANG=en_US.UTF-8

#Langue Systeme
#LC_MESSAGES=en_US.UTF

# PATH
export PATH=$PATH:/home/francis/Scripts:~/.local/share/kyrat/bin

# Auto completion via sudo
complete -cf sudo

# Integration shell de fzf
#eval "$(fzf --bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#### Debut Prompt ####

case "$TERM" in
	xterm-color|*-256color|xterm-ghostty) color_prompt=yes;;
esac

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    prompt_color='\[\033[;32m\]'
    info_color='\[\033[1;34m\]'
    white='\[\033[1;37m\]'
    prompt_symbol=@

    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
        prompt_color='\[\033[;94m\]'
        info_color='\[\033[1;31m\]'
        # Skull emoji for root terminal
        prompt_symbol=💀
    fi
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PS1=$prompt_color'┌──('$info_color'\u'$white$prompt_symbol$info_color'\h'$prompt_color')-[\[\033[0;1m\]\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] ';;
        oneline)
            PS1=''$info_color'\u@\h\[\033[00m\]:'$prompt_color'\[\033[01m\]\w\[\033[00m\]\$ ';;
        backtrack)
            PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ';;
    esac
    unset prompt_color
    unset info_color
    unset prompt_symbol
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

#### Fin Prompt ####

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    if command -v eza >/dev/null 2>&1; then
        alias ls='eza --color=auto --icons'
		alias ll='ls -lg'¬
		alias la='ls -A'¬
 		alias lt='ls -lhTL1 --no-permissions --no-user'¬
 		alias ltt='ls -lhTL2 --no-permissions --no-user'¬
    else
        alias ls='ls --color=auto'
		alias ll='ls -l'
		alias la='ls -A'
    	#alias l='ls -CF'
    fi

    alias vi='vim'
    alias nano='nano -l'
    alias ip='ip -color'
    alias soft-reboot='systemctl soft-reboot'

	alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

	#alias hx='helix'
    #alias emacs='emacs -nw'
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Wrapper inspiré de kyrat pour su (encodage base64)
function suroot() {
    local tmpdir="/tmp/.suroot_$$"
    local src_dir
    local bashrc_name vimrc_name

    if [[ -n "${KYRAT_HOME-}" && -f "${KYRAT_HOME}/bashrc" ]]; then
        # Session kyrat : fichiers sans le point
        src_dir="${KYRAT_HOME}"
        bashrc_name="bashrc"
        vimrc_name="vimrc"
    elif [[ -n "${BASH_SOURCE[0]-}" && "${BASH_SOURCE[0]}" == /tmp/* ]]; then
        # Fallback autre outil similaire : on teste les deux formes
        src_dir="$(dirname "${BASH_SOURCE[0]}")"
        bashrc_name="$(basename "${BASH_SOURCE[0]}")"
        vimrc_name="vimrc"  # à adapter si nécessaire
    else
        # Session locale classique : fichiers avec le point
        src_dir="${HOME}"
        bashrc_name=".bashrc"
        vimrc_name=".vimrc"
    fi

    local src_bashrc="${src_dir}/${bashrc_name}"
    local src_vimrc="${src_dir}/${vimrc_name}"

    echo "[suroot] Dotfiles sourcés depuis : ${src_dir}"
    echo "[suroot] bashrc : ${src_bashrc}"
    echo "[suroot] vimrc  : ${src_vimrc}"

    local b64_bashrc b64_vimrc
    b64_bashrc=$(base64 -w0 "${src_bashrc}" 2>/dev/null || echo "")
    b64_vimrc=$(base64 -w0 "${src_vimrc}" 2>/dev/null || echo "")

    su - root -s /bin/bash -c "
        mkdir -p ${tmpdir}
        echo '${b64_bashrc}' | base64 -d > ${tmpdir}/.bashrc
        echo '${b64_vimrc}'  | base64 -d > ${tmpdir}/.vimrc
        export SUROOT_SESSION=1
        export SUROOT_DOTDIR=${tmpdir}
        export VIMINIT='source ${tmpdir}/.vimrc'
        bash --rcfile ${tmpdir}/.bashrc
        rm -rf ${tmpdir}
    "
}
