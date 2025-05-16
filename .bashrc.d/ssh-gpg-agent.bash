# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ -S /run/user/${UID}/gnupg/S.gpg-agent.ssh ]; then
  export SSH_AUTH_SOCK="/run/user/${UID}/gnupg/S.gpg-agent.ssh"
fi
