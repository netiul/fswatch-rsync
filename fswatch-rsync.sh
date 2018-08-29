#/usr/bin/env bash
set -e

rsync -a -vv --delete ${SYNC_EXCLUDE_ARGS} ${VOLUME}/ rsync://host.docker.internal:${RSYNC_HOST_PORT}/${RSYNC_MODULE} &

fswatch -ordIE -1 --event AttributeModified --event Created --event Link --event MovedFrom --event MovedTo --event Renamed --event Removed --event Updated ${SYNC_EXCLUDE_ARGS} ${VOLUME} | while read num; do
  while read pid; do kill $pid; done < <(jobs -p -r)
  rsync -a -vv --delete ${SYNC_EXCLUDE_ARGS} ${VOLUME}/ rsync://host.docker.internal:${RSYNC_HOST_PORT}/${RSYNC_MODULE}
done

# rsync -a --delete ${VOLUME}/ rsync://host.docker.internal:${RSYNC_HOST_PORT}/${RSYNC_MODULE} &

# fswatch -ordIE --latency 2 --event AttributeModified --event Created --event Link --event MovedFrom --event MovedTo --event Renamed --event Removed --event Updated ${VOLUME} | while read num; do
#   while read pid; do kill $pid; done < <(jobs -p -r)
#   rsync -a -vv --delete ${VOLUME}/ rsync://host.docker.internal:${RSYNC_HOST_PORT}/${RSYNC_MODULE} &
# done