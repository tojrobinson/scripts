#!/bin/bash

REMOTE_USER=""
REMOTE_HOST=""
PORT=""
REMOTE_TARGET="${REMOTE_USER}@${REMOTE_HOST}"
REMOTE_DB=""
LOCAL_DIR=""
REMOTE_DIR=""
DUMP_FILE="db_dump_$(date +\%Y-\%m-\%d-\%H).sql.gz"

ssh -p ${PORT} ${REMOTE_TARGET} pg_dump -U ${REMOTE_USER} -d ${REMOTE_DB} | gzip > ${REMOTE_DIR}/${DUMP_FILE}"
scp -P ${PORT} ${REMOTE_TARGET}:${REMOTE_DIR}/${DUMP_FILE} $LOCAL_DIR
ssh coeus "rm ${REMOTE_DIR}/${DUMP_FILE}"

echo "${REMOTE_DB} was backed up to ${LOCAL_DIR}/${DUMP_FILE}"
