if [ $(which gpg-agent) ] ; then
  #echo "agent exists"
  if $(grep -qs '^[[:space:]]*use-agent' "${HOME}/.gnupg/gpg.conf" && grep -qs '^[[:space:]]*enable-ssh-support' "${HOME}/.gnupg/gpg-agent.conf") ; then
    #echo "gpg enabled"
    unset -v SSH_AGENT_PID
    if [ -e "${HOME}/.gpg-agent-info" ]; then
      . $HOME/.gpg-agent-info
      if [ ! -d /proc/$SSH_AGENT_PID ] ; then
        #echo "pid inactive"
        gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info" > /dev/null
        . ${HOME}/.gpg-agent-info
      fi
    else
      gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info" > /dev/null
      . ${HOME}/.gpg-agent-info
    fi
  fi
fi
