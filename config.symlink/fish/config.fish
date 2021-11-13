set -x FISH $HOME/.config/fish

if test (hostname) = "Neo-neo.local"
    set -x THIS_MACHINE NeoNeo
else
    set -x THIS_MACHINE WorkBook
end

# load the config files
for file in $FISH/config/*.fish
    source $file
end

# Theming
set fish_greeting '⚡️'

function fish_title
    echo (basename $PWD)
end

# Set locale to en_us
export LC_ALL=en_US.UTF-8

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias c="cd ~/Code"
alias g="git"
alias h="history"
alias j="jobs"

## bsb
alias bsc="yarn bsb -clean-world -make-world"
alias bsm="yarn bsb -make-world"
alias bsw="yarn bsb -make-world -w"
alias bscw="yarn bsb -clean-world -make-world -w"

# Replace stuff
alias cat="ccat"

# List all files colorized in long format
alias l="ls -lF -G"

# List all files colorized in long format, including dot files
alias la="ls -laF -G"

# Always use color output for `ls`
alias ls="command ls -G"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# FFS! (last command as sudo)
alias ffs='sudo (fc -ln -1)'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." and date and time cat and date'

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install -g npm@latest; npm update -g; sudo gem update --system; sudo gem update'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user and killall Finder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true & killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false & killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false and killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true and killall Finder"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Start ios simulator
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"

# Linear
alias lc="lin checkout"
alias ln="lin new"

fish_add_path /opt/homebrew/opt/node@16/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/eldh/google-cloud-sdk/path.fish.inc' ]
    . '/Users/eldh/google-cloud-sdk/path.fish.inc'
end
