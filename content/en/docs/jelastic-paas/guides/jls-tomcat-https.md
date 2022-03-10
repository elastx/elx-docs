---
title: "Force HTTPS with Tomcat"
description: "Configure Tomcat to only use HTTPS traffic"
weight: 1
alwaysopen: true
---

## Overview

This guide describes how to make Tomcat force all traffic over HTTPS.

## Tomcat Configuration

On the Tomcat node, edit the web.xml file and add the following in the `<web-app *>` section.

```
    <security-constraint>
        <web-resource-collection>
            <web-resource-name>Protected Context</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <!-- auth-constraint goes here if you require authentication -->
        <user-data-constraint>
            <transport-guarantee>CONFIDENTIAL</transport-guarantee>
        </user-data-constraint>
    </security-constraint>
```

With this, Tomcat will attempt to redirect any HTTP request to the specified context and instead use the HTTPS Connector, and as such never serve it under HTTP.

If you are using the shared Jelastic SSL certificate or if you are using a load balancer in front of your Tomcat node, you will need to make the below changes.
This is to make Tomcat understand `X-Forwarded-Proto` by adding the following text in the Tomcat server.xml `<Engine>` section. 


```
    <Connector port="8080" protocol="HTTP/1.1"
    connectionTimeout="20000"
    redirectPort="443" />
```

We also need to adjust the `redirectPort` on the connector. 
It should redirect users to 443 (and not 8443).

_Note: 8443 is the internal port Tomcat listens on, but the Jelastic resolver pushes traffic to 443 and it's translated to the correct Tomcat port for you automatically. So 443 is the correct port for HTTPS requests._

Edit the server.xml file and change the connector redirect to port 443.

```
    <Connector port="8080" protocol="HTTP/1.1"
    connectionTimeout="20000"
    redirectPort="443" />
```

Restart the Tomcat node and it should be done.
