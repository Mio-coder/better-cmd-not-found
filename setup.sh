# shellcheck shell=sh

command_not_found_handle() {
    # shellcheck disable=SC2317
    @out@/bin/better-cmd-not-found "$@"
    return $?
}
command_not_found_handler() {
    # shellcheck disable=SC2317
    @out@/bin/better-cmd-not-found "$@"
    return $?
}
