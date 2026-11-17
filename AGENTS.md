# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Overview

Markdown sources for the documentation of the `vpc` R package (https://github.com/ronkeizer/vpc), published at vpc.ronkeizer.com. The site is a GitBook 3.2.3 book. The built HTML is **not** deployed from this repo: it is copied into the `docs/` folder of the `vpc` repo, which GitHub Pages deploys on every push to its `master` branch.

## Layout

- `README.md`: landing page (Introduction, Quick start, What's new).
- `SUMMARY.md`: table of contents / sidebar navigation. Add new pages here.
- `*.md`: one file per page.
- `book.json`: GitBook config (plugins `mathjax`, `expandable-chapters`, `toc`).
- `public/`: built HTML (committed). Never edit it by hand; rebuild it.
- `Dockerfile`, `build.sh`: build tooling. `.bookignore` keeps them out of the built site.

## Workflow

1. Edit the markdown (and `SUMMARY.md` for new or renamed pages). Check argument names and defaults against the `vpc` package source (roxygen docs in `R/`, `NEWS.md`).
2. Build: `./build.sh` (needs Docker). This writes `public/`.
3. Copy the build into the `vpc` repo: `rsync -a --exclude .gitignore public/ <path-to-vpc>/docs/`.
4. Commit and open a PR in both repos. In the `vpc` repo, docs for features that are not yet on `master` should merge together with (or after) those features, since `master` deploys immediately.

## Build gotchas

`build.sh` already handles these. Keep them in mind if you change the build:

- GitBook 3.2.3 does not run on modern Node, so it runs in a `node:10` Docker image.
- `gitbook install` crashes ("Missing required argument #1"). Plugins are installed with `npm install --before=2017-11-15` instead.
- `gitbook-plugin-mathjax@1.1.2` was published with merge-conflict markers and won't load, so it is pinned to `1.1.1`. Version 2.0.0 (2026) is incompatible.
- `public/` must be removed before building; otherwise GitBook copies it into the output as `public/public/`.
- Every build changes the timestamps embedded in all pages, so all HTML files show a diff even if their content is unchanged.
