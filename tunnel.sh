#!/user/bin/env bash

LOCAL_PROCESS_PORT=""
REMOTE_PROCESS_PORT=""
USER=""
HOST=""
PORT=""

ssh -L $LOCAL_PROCESS_PORT:localhost:$REMOTE_PROCESS_PORT $USER@$HOST -p $PORT
