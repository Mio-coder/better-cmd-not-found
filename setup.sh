# shellcheck shell=sh

if [ -n "$BASH_VERSION" ]; then
    command_not_found_handle() {
        # shellcheck disable=SC2317
        @out@/bin/better-cmd-not-found "$@"
        return $?
    }
elif [ -n "$ZSH_VERSION" ]; then
    command_not_found_handler() {
        # shellcheck disable=SC2317
        @out@/bin/better-cmd-not-found "$@"
        return $?
    }
fi
