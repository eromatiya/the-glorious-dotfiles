# Disable CSD of GTK3 Apps
# More explanation here
# https://github.com/PCMan/gtk3-nocsd
export GTK_CSD=0
export LD_PRELOAD=/lib/libgtk3-nocsd.so.0

# Editor
export EDITOR='nvim'

# Include ~/.local/bin into PATH
export PATH="${PATH}:$HOME/.local/bin/"

# Include ruby gems bin into PATH
export PATH="#{PATH}:$HOME/.gem/ruby/2.6.0/bin/"

RANGER_LOAD_DEFAULT_RC=FALSE


