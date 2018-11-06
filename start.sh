#!/bin/bash

TASK=$1
DATADIR='/data/.ethereum'
BOOTNODE='enode://a24ac7c5484ef4ed0c5eb2d36620ba4e4aa13b8c84684e1b4aab0cebea2ae45cb4d375b77eab56516d34bfbd3c1a833fc51296ff084b770b94fb9028c4d25ccf@52.169.42.101:30303'

if [ "$TASK" == "START" ]; then
	/usr/bin/sudo /usr/sbin/sshd && \
	/usr/bin/geth \
	  --networkid=4 \
	  --datadir=${DATADIR} \
	  --syncmode=light --cache 1024 \
	  --rpc --rpcapi "eth,net" \
	  --maxpeers 50 -v5disc \
	  --bootnodes=${BOOTNODE}
else if [ "$TASK" == "INIT" ]; then
	/usr/bin/geth \
	  --datadir=${DATADIR} \
	  init \
	  /etc/rinkeby.json && \
	/usr/bin/cp -f /etc/static-nodes.json ${DATADIR}/geth/
fi
