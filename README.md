# ELASTX Customer Docs

This documentation is generated using Hugo

## Getting started

To run a local server, it is very easy:

```bash
$ git submodule init
$ git submodule update
$ hugo server
```

## Deploy code to google app engine

To deploy the current version to app-engine

Make sure you have configured gcloud with the project `elx-docs`
```
gcloud config project elx-docs
```

```bash
$ git submodule init
$ git submodule update
$ hugo
$ gcloud app deploy
```

