# ELASTX Customer Docs

This documentation is generated using Hugo

## Getting started

To run a local server, it is very easy:

```bash
$ git submodule init
$ git submodule update
$ docker run -ti -p 1313:1313 -v (pwd):/root/project quay.io/elastx/ci-hugo:0.59.1 hugo serve --bind 0.0.0.0
Building sites [...]
```

Now you should be able to access the site through [http://localhost:1313/](http://localhost:1313/)


## Deploy code to google app engine

To deploy the current version to app-engine

Make sure you have configured gcloud with the project `elx-docs`

```bash
$ gcloud auth login
Your browser has been opened to visit: [...]
$ gcloud config set project elx-docs
Updated property [core/project].
```

Initialize submodule (docdock theme) and generate the static site (using docker) and then deploy with `gcloud app deploy`.

```bash
$ git submodule init
$ git submodule update
$ docker run -ti -e HUGO_ENV=production -p 1313:1313 -v (pwd):/root/project quay.io/elastx/ci-hugo:0.59.1 hugo
$ gcloud app deploy
Services to deploy:

descriptor:      [/Users/tobias/src/github.com/elastx/elx-docs/app.yaml]
source:          [/Users/tobias/src/github.com/elastx/elx-docs]
target project:  [elx-docs]
target service:  [default]
target version:  [20200217t091220]
target url:      [https://elx-docs.appspot.com]

Do you want to continue (Y/n)?
```

