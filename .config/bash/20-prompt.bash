
# ANSII color codes for prompt
# shellcheck disable=SC2034
{
    RESET="\[\033[0m\]"
    RED="\[\033[00;31m\]"
    RED_BOLD="\[\033[01;31m\]"
    GREEN="\[\033[00;32m\]"
    GREEN_BOLD="\[\033[01;32m\]"
    YELLOW="\[\033[00;33m\]"
    YELLOW_BOLD="\[\033[01;33m\]"
    BLUE="\[\033[00;34m\]"
    BLUE_BOLD="\[\033[01;34m\]"
    MAGENTA="\[\033[00;35m\]"
    MAGENTA_BOLD="\[\033[01;35m\]"
    CYAN="\[\033[00;36m\]"
    CYAN_BOLD="\[\033[01;36m\]"
    WHITE="\[\033[00;97m\]"
    WHITE_BOLD="\[\033[01;97m\]"
}

# See https://git-scm.com/docs/git-status
function prompt_git() {
    local prompt=""

    local git_status
    if ! git_status=$(git status --porcelain=v2 --branch --show-stash 2>/dev/null); then
        # Not a Git repository (or some error occurred).
        printf -v "$1" '%s' "${prompt}"
        return
    fi

    local oid=""
    local branch=""
    local stash=0
    local ahead=0
    local behind=0
    local staged=0
    local changed=0
    local conflicts=0
    local untracked=0

    while IFS= read -r line || [[ -n $line ]]; do
        case "${line:0:1}" in
            '#')
                IFS=' ' read -r -a array <<< "${line:1}"
                if [[ "${array[0]}" == "branch.oid" ]]; then
                    oid="${array[1]}"
                elif [[ "${array[0]}" == "branch.head" ]]; then
                    # if detached, remove '(' and ')' with tr
                    branch=$(echo "${array[1]}" | tr -d "()")
                elif [[ "${array[0]}" == "branch.ab" ]]; then
                    ahead="${array[1]:1}"
                    behind="${array[2]:1}"
                elif [[ "${array[0]}" == "stash" ]]; then
                    stash="${array[1]}"
                fi
                ;;
            '1' | '2')
                if [[ "${line:2:1}" != "." ]]; then
                    staged=$((staged+1))
                fi
                if [[ "${line:3:1}" != "." ]]; then
                    changed=$((changed+1))
                fi
                ;;
            'u')
                conflicts=$((conflicts+1))
                ;;
            '?')
                untracked=$((untracked+1))
                ;;
        esac
    done < <(printf '%s' "${git_status}")

    # Build the git prompt
    prompt=":${oid:0:7}"

    if [[ "${branch}" == "detached" ]]; then
        # Check if we're checked out to a tag
        local tag
        tag=$(git describe --tags --exact-match 2>/dev/null)
        if [[ -n "${tag}" ]]; then
            branch="${branch}:${tag}"
        fi
    fi

    prompt="${prompt}:${branch}"

    local state=""

    if [[ $ahead -ne 0 ]]; then state="${state}:↑$ahead"; fi
    if [[ $behind -ne 0 ]]; then state="${state}:↓$behind"; fi
    if [[ $changed -ne 0 ]]; then state="${state}:✗${changed}"; fi
    if [[ $staged -ne 0 ]]; then state="${state}:${staged}"; fi
    if [[ $untracked -ne 0 ]]; then state="${state}:${untracked}"; fi
    if [[ $conflicts -ne 0 ]]; then state="${state}:${conflicts}"; fi
    if [[ $stash -ne 0 ]]; then state="${state}:${stash}"; fi
    if [[ -z "${state}" ]]; then state=":✓"; fi

    prompt="${prompt}(${state})"
    printf -v "$1" '%s' "${prompt}"
}

# TODO: Not possible to manually deactivate environment if inside path (just gets activated
#       automatically again). Not sure if this is much of a problem as you generally want
#       to use the venv. See custom venv function (above) for management of venv's.
function prompt_python_venv {
    local prompt=""

    # Auto enable/disable python venv
    if [[ -z "${VIRTUAL_ENV}" ]]; then
        # TODO: Implement look-behind to see if parent directories have a venv (and activate top most venv instead)
        if [[ -f "$PWD/venv/pyvenv.cfg" ]]; then
            . "$PWD/venv/bin/activate"
        elif [[ -f "$PWD/.venv/pyvenv.cfg" ]]; then
            . "$PWD/.venv/bin/activate"
        fi
    else
        local parentdir
        parentdir="$(dirname "$VIRTUAL_ENV")"

        # A venv is already active, should we deactivate it?
        if [[ "$PWD"/ != "$parentdir"/* ]] ; then
            # Current working directory is not a subdir of venv parent directory
            deactivate

            # Should we activate the venv for the current working directory?
            if [[ -f "$PWD/venv/pyvenv.cfg" ]]; then
                . "$PWD/venv/bin/activate"
            elif [[ -f "$PWD/.venv/pyvenv.cfg" ]]; then
                . "$PWD/.venv/bin/activate"
            fi
        fi
    fi

    # The prompt
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        local name
        name=$(basename "$(dirname "$VIRTUAL_ENV")")
        prompt="${prompt}${MAGENTA_BOLD}:${name}${RESET} "
    fi

    printf -v "$1" '%s' "${prompt}"
}

function prompt_command {
    prompt="${GREEN_BOLD}┌  \u"
    prompt="${prompt} ${CYAN_BOLD} \h"
    prompt="${prompt} ${BLUE_BOLD} \W${RESET} "

    local output=""
    prompt_git output
    prompt="${prompt}${YELLOW_BOLD}${output}${RESET}"

    prompt_python_venv output
    prompt="${prompt} ${MAGENTA_BOLD}${output}${RESET}"

    prompt="${prompt}\n${GREEN_BOLD}└┄ ${RESET}"

    PS1="${prompt}"
    PS2="${YELLOW_BOLD}➜${RESET} "
}

export PROMPT_COMMAND=prompt_command
