#
# Xcode
#
# Xcode is an integrated development environment for macOS.
# Link: https://developer.apple.com/xcode/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_XCODE_ASYNC="${SPACESHIP_XCODE_ASYNC=true}"
SPACESHIP_XCODE_SHOW_LOCAL="${SPACESHIP_XCODE_SHOW_LOCAL=false}"
SPACESHIP_XCODE_SHOW_GLOBAL="${SPACESHIP_XCODE_SHOW_GLOBAL=true}"
SPACESHIP_XCODE_PREFIX="${SPACESHIP_XCODE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_XCODE_SUFFIX="${SPACESHIP_XCODE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_XCODE_SYMBOL="${SPACESHIP_XCODE_SYMBOL="🛠 "}"
SPACESHIP_XCODE_COLOR="${SPACESHIP_XCODE_COLOR="blue"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show current version of Xcode
spaceship_xcode() {
  spaceship::exists xcode-select || return

  # If there are xcode-specific files in current directory
  local is_xcode_project="$(spaceship::upsearch *.xcworkspace *.xcodeproj)"
  [[ -n "$is_xcode_project" ]] || return

  local xcode_path

  if spaceship::exists xcenv; then
    if [[ $SPACESHIP_XCODE_SHOW_GLOBAL == true ]] ; then
      xcode_path=$(xcenv version | sed 's/ .*//')
    elif [[ $SPACESHIP_XCODE_SHOW_LOCAL == true ]] ; then
      if xcenv version | grep ".xcode-version" > /dev/null; then
        xcode_path=$(xcenv version | sed 's/ .*//')
      fi
    fi
  else
    # Get xcode path from xcode-select
    xcode_path=$(xcode-select -p | cut -d / -f -3)
  fi

  if [ -n "${xcode_path}" ]; then
    local xcode_version_path=$xcode_path"/Contents/version.plist"
    if [ -f ${xcode_version_path} ]; then
      if spaceship::exists defaults; then
        local xcode_version=$(defaults read ${xcode_version_path} CFBundleShortVersionString)

        spaceship::section \
          --color "$SPACESHIP_XCODE_COLOR" \
          --prefix "$SPACESHIP_XCODE_PREFIX" \
          --suffix "$SPACESHIP_XCODE_SUFFIX" \
          --symbol "$SPACESHIP_XCODE_SYMBOL" \
          "$xcode_version"
      fi
    fi
  fi
}
