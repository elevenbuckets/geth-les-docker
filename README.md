## 1. start container
- Setup New LES2 sync, where DATADIR=${BASEDIR}/.ethereum
```
docker run --rm -t \
-v"${BASEDIR}:/data:z" \
--entrypoint="/usr/bin/start.sh" \
docker.io/infwonder/geth_stunnel_rinkeby_les2:latest \ 
INIT
```

- Once setup, launching container:
```
docker run --name "geth_stunnel_rinkeby_les2" \
      -td -v${BASEDIR}:/data:z" \
      --entrypoint="/usr/bin/start.sh" \
      docker.io/infwonder/geth_stunnel_rinkeby_les2:latest \
      START
```

## 2. setup ssh tunnel to port 8545 (geth rpc on localhost inside container):
  ```
     ssh -L 8545:localhost:8545 -N -f -l eleven ${container_ip_address}
  ```

## 3. configure and start CastIron_UI, talking to geth rpc via ssh tunnel!

### Note: this is designed to be used by 11BE Dev Preview distribution, which comes with fully auto-mated container setup. 
