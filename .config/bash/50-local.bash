# Vault
export VAULT_ADDR='https://192.168.1.103:8200'
if [[ -r ~/.vault-token ]]; then
    VAULT_TOKEN="$(<~/.vault-token)"
    export VAULT_TOKEN
fi

# ESP-IDF
export ESPPORT=/dev/ttyACM0
export ESPBAUD=921600

# TI sysconfig
alias sysconfig='/home/og/ti/sysconfig_${SYSCONFIG_VERSION:-1.8.2}/sysconfig_cli.sh'
