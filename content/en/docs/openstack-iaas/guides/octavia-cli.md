---
title: "Octavia CLI"
description: "Load balancer as a service for OpenStack"
weight: 1
alwaysopen: true
---

*OpenStack Octavia* is the next generation load balancer as a service for OpenStack.


This guide is structured in two parts. <br/> <br/>

Steps 1-4 are based on Elastx's official getting started guide with Openstack (link below), where we go through the initials steps which are required to set up everything that is needed in order to start using Openstack platform: here we'll create and configure a network, subnet, router, create ssh-keys and configure security groups. <br>

https://docs.elastx.cloud/docs/openstack-iaas/guides/getting_started/

<br/>

Under steps 5-8 we'll set up 3 Nginx webservers across 3 diffent availability zones, create and configure load balancer which will redistribute traffic evenly between all 3 availability zones. And we'll also add a health monitor and finally we'll add a TLS terminated traffic for our webservers.

<br/>

**Step 1 . Create internal network and subnet**

```shell
$ openstack network create "internal_network"
```

```shell
$ openstack subnet create "internal_subnet" \
         --network "internal_network" \
         --subnet-range "10.0.1.0/24" \
         --dns-nameserver "1.1.1.1" \
         --dns-nameserver "1.0.0.1" \ 
         --allocation-pool start=10.0.1.100,end=10.0.1.200 \
         --dhcp
```

**Step 2. Create Router**

```shell
$ openstack router create "R3" --external-gateway "elx-public1"
```

**Step 2.1 Connect router with the internal subnet**
```shell
$ openstack router add subnet "R3" "internal_subnet"
```

**Step 3. Create Security Group and open ports**

```shell
$ openstack security group create "new-sec-group"


$ openstack security group rule create \
         --protocol "TCP" \
         --dst-port "22" \
         --ingress \
         new-sec-group 

$ openstack security group rule create \
         --protocol "TCP" \
         --dst-port "80" \
         --ingress \
         new-sec-group 

```

**Step 4.1 Copy your  public SSH-key to clipboard**
```shell
$ xclip -sel clip < ~/.ssh/id_ed25519.pub

```

**Step 4.2 Paste contents of clipboard inside vim and save it**
```shell
$ vim my-key.pub
```

**Step 4.3 Import your key**
```shell
$ openstack keypair create --public-key "my-key.pub" my-key  
```

**Step 5. Create 3 Virtual Machines on the internal network**

First we need to create our user-data files with a simple configuration which will allow our newly created instances to automatically install and enable Nginx webserver.
We'll create a separate user-data file for each Virtual Machine, the reason for this is that we need to somehow verify that our load balancer is actually working - this 
will be achived by modifying text on the default index.html page which is automatically created on Nginx installation.

And the second reason for using cloud-init is because it makes life easier for us, since we will not need to login into each newly created Virtual Machine and manually 
install and enable Nginx: cloud-init will take care of this for us.

**Step 5.1 Prepare and launch first instance which will be placed on availability zone "STO1"**

```shell
$ cat << EOF > user-data-sto1.yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - sed -i 's/Welcome to nginx!/Welcome to nginx! STO1/' /var/www/html/index.nginx-debian.html
EOF
```

```shell
$ openstack server create \
         --image "ubuntu-22.04-server-latest" \
         --flavor "v1-small-1" \
         --security-group "new-sec-group" \
         --key-name "my-key" \
         --availability-zone "sto1" \
         --network "internal_network" \
         --user-data "user-data-sto1.yaml" \
         nginx-wb-sto1
```

**Step 5.2 Prepare and launch second instance which will be placed on availability zone "STO2"**

```shell
$ cat << EOF > user-data-sto2.yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - sed -i 's/Welcome to nginx!/Welcome to nginx! STO2/' /var/www/html/index.nginx-debian.html
EOF
```

```shell
$ openstack server create \
         --image "ubuntu-22.04-server-latest" \
         --flavor "v1-small-1" \
         --security-group "new-sec-group" \
         --key-name "my-key" \
         --availability-zone "sto2" \
         --network "internal_network" \
         --user-data "user-data-sto2.yaml" \
         nginx-wb-sto2
```

**Step 5.3 Prepare and launch third instance which will be placed on availability zone "STO3"**


```shell
$ cat << EOF > user-data-sto3.yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - sed -i 's/Welcome to nginx!/Welcome to nginx! STO3/' /var/www/html/index.nginx-debian.html
EOF
```

```shell
$ openstack server create \
         --image "ubuntu-22.04-server-latest" \
         --flavor "v1-small-1" \
         --security-group "new-sec-group" \
         --key-name "my-key" \
         --availability-zone "sto3" \
         --network "internal_network" \
         --user-data "user-data-sto3.yaml" \
         nginx-wb-sto3
```

**Step 6.1 Create and configure load balancer**

First you need to get the ID for the internal subnet

```shell
$ openstack subnet show "internal_subnet" -c id -f value

4776fced-617c-4230-9db3-c027a76f61e7

```

Then create load balancer.

```shell
$ openstack loadbalancer create \
         --name "http-lb" \
         --vip-subnet-id "4776fced-617c-4230-9db3-c027a76f61e7"


```

**Step 6.2 Create a Floating IP**

```shell
$ openstack floating ip create "elx-public1"

+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| created_at          | 2023-02-02T09:59:43Z                 |
| description         |                                      |
| dns_domain          |                                      |
| dns_name            |                                      |
| fixed_ip_address    | None                                 |
| floating_ip_address | 91.197.42.77                         |
| floating_network_id | 600b8501-78cb-4155-9c9f-23dfcba88828 |
| id                  | 68936e33-6853-4747-9f6e-b99f9363bca6 |
| name                | 91.197.42.77                         |
| port_details        | None                                 |
| port_id             | None                                 |
| project_id          | 711120f35c7643b081ecc845ea6b64fa     |
| qos_policy_id       | None                                 |
| revision_number     | 0                                    |
| router_id           | None                                 |
| status              | DOWN                                 |
| subnet_id           | None                                 |
| tags                | []                                   |
| updated_at          | 2023-02-02T09:59:43Z                 |
+---------------------+--------------------------------------+
```

**Step 6.3 Bind Floating IP to the load balancer**

First you need to get the port id (vip_port_id) for the newly created load balancer:

```shell
$ openstack loadbalancer show "http-lb" -c vip_port_id -f value

b06809c7-24b2-48e1-9398-d0cab75d5e32
```

Then we'll associate our load balancer with the Floating IP we created during step 6.2 

```shell
$ openstack floating ip set --port "b06809c7-24b2-48e1-9398-d0cab75d5e32" "91.197.42.77"

```

**Step 6.4 HTTP and SSH listeners**

Our three instances are on our internal network (internal_network) which we created during Step 1. The next step is to link those instances with our load balancer.

First we'll create a listener on port 80 which will be common for all three of our instances.

```shell
$ openstack loadbalancer listener create \
         --protocol "HTTP" \
         --protocol-port "80" \
         --name "http-lb-listener" \
         http-lb
```

Next we'll create a SSH listener for each instance. 

- We are going to use port 2201 to access our instance in sto1 ( which we named nginx-wb-sto1 ) on port 22

```shell
$ openstack loadbalancer listener create \
         --protocol "TCP" \
         --protocol-port "2201" \
         --name "lb-ssh-listener-sto1" \
         http-lb
```

- We are going to use port 2202 to access our instance in sto2 ( which we named nginx-wb-sto2 ) on port 22

```shell
$ openstack loadbalancer listener create \
         --protocol "TCP" \
         --protocol-port "2202" \
         --name "lb-ssh-listener-sto2" \
         http-lb
```
- We are going to use port 2203 to access our instance in sto3 ( which we named nginx-wb-sto3 ) on port 22

```shell
$ openstack loadbalancer listener create \
         --protocol "TCP" \
         --protocol-port "2203" \
         --name "lb-ssh-listener-sto3" \
         http-lb
```

**Step 6.5 Create Pools**
```shell
$ openstack loadbalancer pool create \
         --listener "http-lb-listener" \
         --protocol "HTTP" \
         --lb-algorithm "ROUND_ROBIN" \
         --name "http-lb-pool"
```

```shell
$ openstack loadbalancer pool create \
         --lb-algorithm "ROUND_ROBIN"  \
         --listener "lb-ssh-listener-sto1" \
         --protocol "TCP" \
         --session-persistence type=SOURCE_IP \
         --name "pool-lb-ssh-listener-sto1"


$ openstack loadbalancer pool create \
         --lb-algorithm "ROUND_ROBIN"  \
         --listener "lb-ssh-listener-sto2" \
         --protocol "TCP" \
         --session-persistence type=SOURCE_IP \
         --name "pool-lb-ssh-listener-sto2"

$ openstack loadbalancer pool create \
         --lb-algorithm "ROUND_ROBIN"  \
         --listener "lb-ssh-listener-sto3" \
         --protocol "TCP" \
         --session-persistence type=SOURCE_IP \
         --name "pool-lb-ssh-listener-sto3"
```

**Step 6.6 Add members to our newly created pools**


```shell
$ openstack loadbalancer member create \
         --subnet-id "internal_subnet" \
         --address "10.10.10.117" \
         --protocol-port "22" \
         pool-lb-ssh-listener-sto1


$ openstack loadbalancer member create \
         --subnet-id "internal_subnet" \
         --address "10.10.10.100" \
         --protocol-port "22" \
         pool-lb-ssh-listener-sto2

$ openstack loadbalancer member create \
         --subnet-id "internal_subnet" \
         --address "10.10.10.187" \
         --protocol-port "22" \
         pool-lb-ssh-listener-sto3

---

$ openstack loadbalancer member create \                                                                                                                                                                                                   
         --name "member-nginx-wb-sto1" \
         --subnet-id "internal_subnet" \
         --address "10.10.10.117" \
         --protocol-port "80" \
         http-lb-pool


$ openstack loadbalancer member create \                                                                                                                                                                             
         --name "member-nginx-wb-sto2" \
         --subnet-id "internal_subnet" \
         --address "10.10.10.100" \
         --protocol-port "80" \
         http-lb-pool

$ openstack loadbalancer member create \                                                                                                                                                                             
         --name "member-nginx-wb-sto3" \
         --subnet-id "internal_subnet" \
         --address "10.10.10.187" \
         --protocol-port "80" \
         http-lb-pool
```

We are now done with the basic configuration of our load balancer. To verify this, open up a web browser and open 

`` 
http://YOUR_FLOATING_IP/
``   

In our case, the IP is:<br/>
`` 
http://91.197.42.77/
``
<br/>

Now you'll  see Nginx's default welcome page and which availability zone you landed on - which was the point of using cloud-init during
Step 5. If you reload the page you'll land on the next availability zone. Order / Priority which will decide which availability zone 
the load balancer will redirect to can be set by adding ``--weight <NUM>`` flag to the command entered during Step 6.6


![Nginx STO1](/img/openstack-iaas/guides/ops_octavia_url-1.png)


- Now you also should be able to SSH into your instances using the load balancer's public ip (Floating IP)

```bash
$ ssh ubuntu@91.197.42.77 -p 2201 

$ ssh ubuntu@91.197.42.77 -p 2202

$ ssh ubuntu@91.197.42.77 -p 2203
```

**Step 7. Health Minitor**

```shell
$ openstack loadbalancer healthmonitor create \
         --delay "7" \
         --max-retries "3" \
         --url-path "/" \
         --timeout "5" \
         --type "HTTP" \
         --expected-codes "200,201" \
         --name "http-lb-monitor" \
         http-lb-pool
```

**Step 8.0 TLS Termination**

In this final section we'll add TLS terminated traffic.


**Step 8.1 Generate a test certificate**

```shell
$ openssl req -newkey rsa:2048 -x509 -sha256 \
         -days 365 -nodes -out tls.crt -keyout tls.key \
         -subj "/CN=DOMAIN_OR_IP/emailAddress=username@domain.com"
```

**Step 8.2 We are going to combine the newly created certificate and key into a single PKCS12 file**

```shell
$ openssl pkcs12 -export -inkey tls.key -in tls.crt -passout pass: -out tls.p12
```

**Step 8.3 Control whether the certificate is valid or or not**

```shell
$ openssl pkcs12 -in tls.p12 -noout -info

Enter Import Password:
MAC: sha256, Iteration 2048
MAC length: 32, salt length: 8
PKCS7 Encrypted data: PBES2, PBKDF2, AES-256-CBC, Iteration 2048, PRF hmacWithSHA256
Certificate bag
PKCS7 Data
Shrouded Keybag: PBES2, PBKDF2, AES-256-CBC, Iteration 2048, PRF hmacWithSHA256
```

**Step 8.4 Now we'll use Openstack's Secret Store (Barbican) to store the certificate**

```shell
$ openstack secret store \
         --name "openstack_tls_secret" \
         --payload-content-type "application/octet-stream" \
         --payload-content-encoding "base64" \
         --payload="$(base64 < tls.p12)"

+---------------+-------------------------------------------------------------------------------+
| Field         | Value                                                                         |
+---------------+-------------------------------------------------------------------------------+
| Secret href   | https://ops.elastx.cloud:9311/v1/secrets/439ac688-4824-4ee3-8883-f663ffe4d11d |
| Name          | openstack_tls_secret                                                          |
| Created       | None                                                                          |
| Status        | None                                                                          |
| Content types | {'default': 'application/octet-stream'}                                       |
| Algorithm     | aes                                                                           |
| Bit length    | 256                                                                           |
| Secret type   | opaque                                                                        |
| Mode          | cbc                                                                           |
| Expiration    | None                                                                          |
+---------------+-------------------------------------------------------------------------------+
```

**Step 8.5 Create a new listener on port 443** 

```shell
$ openstack loadbalancer listener create \
         --protocol-port "443" \
         --protocol "TERMINATED_HTTPS" \
         --default-tls-container=$(openstack secret list | awk '/ openstack_tls_secret / {print $2}') \
         --name "https-lb-listener" \
         http-lb
```

**Step 8.6 Create a new pool for the HTTPS listener**

Our pool member's are serving HTTP content on port 80 - that is the reason why HTTP protocol is defined 
for the pool below.

```shell
$ openstack loadbalancer pool create \                                                                                                                                                                                                     15:02:39
         --listener "https-lb-listener" \
         --lb-algorithm "ROUND_ROBIN" \
         --protocol "HTTP" \
         --name "https-lb-pool"
```

**Step 8.7 Add members to the new pool**

```shell
$ openstack loadbalancer member create \                                                                                                                                                                                                   15:06:53
         --subnet-id "internal_subnet" \
         --address "10.10.10.117" \
         --protocol-port "80" \
         https-lb-pool


$ openstack loadbalancer member create \                                                                                                                                                                                                   15:06:53
         --subnet-id "internal_subnet" \
         --address "10.10.10.100" \
         --protocol-port "80" \
         https-lb-pool


$ openstack loadbalancer member create \                                                                                                                                                                                                   15:06:53
         --subnet-id "internal_subnet" \
         --address "10.10.10.187" \
         --protocol-port "80" \
         https-lb-pool
```

That's it. To verify SSL termination open up a web browser and check:

``
https://YOUR_FLOATING_IP/
``

In our case, the IP is:

``
https://91.197.42.77/
``
