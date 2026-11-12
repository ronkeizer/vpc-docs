#!/bin/sh
# Build the markdown into HTML in public/, using GitBook 3.2.3 in Docker.
#
# GitBook 3.2.3 does not run on modern Node, so the build runs in a node:10
# image (see Dockerfile). `gitbook install` is broken, so the plugins are
# installed with npm directly, pinned to versions from before the original
# build (Nov 2017). gitbook-plugin-mathjax 1.1.2 was published with merge
# conflict markers, so 1.1.1 is used.
#
# The resulting public/ folder is copied to the docs/ folder of the vpc repo,
# which is deployed to GitHub Pages (vpc.ronkeizer.com).
set -e
cd "$(dirname "$0")"

docker build --platform linux/amd64 -t vpc-gitbook .

# public/ must not exist during the build, otherwise gitbook copies it into
# the output as an asset (public/public/).
rm -rf public _book
docker run --rm --platform linux/amd64 -v "$PWD":/book vpc-gitbook sh -c \
  "npm install --no-save --no-package-lock --before=2017-11-15 \
     gitbook-plugin-mathjax@1.1.1 gitbook-plugin-expandable-chapters gitbook-plugin-toc && \
   gitbook build && cp -R _book public"
git checkout -- public/.gitignore

echo "Done. Copy to the vpc repo with:"
echo "  rsync -a --exclude .gitignore public/ <path-to-vpc>/docs/"
