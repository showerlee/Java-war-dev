#!/bin/sh

user=$1
domain=$2
port=$3

declare -i n=1

while ((n<=3))
do
  status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 -p$3 $user@$domain echo ok 2>&1)
  if [[ $status == ok ]]; then
    echo [INFO] sshd is listening on port $3
  elif [[ $status == "Permission denied"* ]] ; then
    echo authentication failed, please check.
  else
    echo $status
  fi
  let ++n
  sleep 3
done

if [[ $status == ok ]]; then
  echo "[INFO] ssh connection available, it is good to go."
fi
