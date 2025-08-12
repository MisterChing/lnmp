#!/bin/bash
#redis-cli -h 127.0.0.1 -p 6379 -a 'Jpc5k3F0qUeCmFz_' monitor | stdbuf -o0 grep --line-buffered '\[${db}' > /dev/stdout
#redis-cli -h 127.0.0.1 -p 6379 -a 'Jpc5k3F0qUeCmFz_' monitor | grep --line-buffered '\[${db}' >> aa.log
#redis-cli -h 127.0.0.1 -p 6379 -a 'Jpc5k3F0qUeCmFz_' monitor | stdbuf -o0 grep '\[${db}'
redis-cli -h 127.0.0.1 -p 6379 -a 'Jpc5k3F0qUeCmFz_' monitor
