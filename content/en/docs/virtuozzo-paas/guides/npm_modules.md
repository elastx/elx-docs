---
title: "Node.JS NPM Module Problems"
description: "How to resolve Node.JS unmet dependency problems when installing modules"
weight: 1
alwaysopen: true
---

## Overview
If you have problems with installing node modules via npm and get "unmet dependency" errors then this guide might help.

## Solution

Try to remove all installed modules, clear the npm cache and reinstall. Log in to the node with ssh and run the following commands:

```bash
cd /home/jelastic/ROOT

npm cache clean --force

rm -r node_modules

npm install
```
