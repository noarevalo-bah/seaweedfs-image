this image packages the seaweedfs `weed` binary from the official release tarball.

seaweedfs release artifacts are published here:
https://github.com/seaweedfs/seaweedfs/releases

set the version in `.env`:

`SEAWEEDFS_VERSION=4.23`

build the image locally:

`docker build --build-arg SEAWEEDFS_VERSION=4.23 -t bah/seaweedfs:4.23 .`

run the local seaweedfs stack (master, volume, filer, s3, webdav):

`docker compose -f docker-compose.yml up --build`

stop the stack:

`docker compose -f docker-compose.yml down`