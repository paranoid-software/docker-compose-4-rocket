docker volume create rocket-api && \
docker run --rm -i -v rocket-api:/data busybox rm -rf /data/*/ && \
tar --exclude='.DS_Store' -C ./api -c -f- . | docker run --rm -i -v rocket-api:/data busybox tar -C ./data -xv -f- && \
docker volume create rocket-bridge && \
docker run --rm -i -v rocket-bridge:/data busybox rm -rf /data/*/ && \
tar --exclude='.DS_Store' -C ./bridge -c -f- . | docker run --rm -i -v rocket-bridge:/data busybox tar -C ./data -xv -f- && \
docker volume create rocket-indexer && \
docker run --rm -i -v rocket-indexer:/data busybox rm -rf /data/*/ && \
tar --exclude='.DS_Store' -C ./indexer -c -f- . | docker run --rm -i -v rocket-indexer:/data busybox tar -C ./data -xv -f-