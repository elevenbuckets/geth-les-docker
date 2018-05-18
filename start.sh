#!/bin/bash

/usr/bin/sudo /usr/sbin/sshd && \
/usr/bin/geth --syncmode light --cache 1024 --rpc --rpcapi "eth,net" --maxpeers 50 -v5disc
