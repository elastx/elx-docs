---
title: "Announcements"
description: "Announcement for the OpenStack cloud"
weight: 1
alwaysopen: true
---

## 2023-03-22 OpenStack IaaS announcement

We are changing the Microsoft licensing model to make it more cost effective and we have also introduced new Load Balancer flavors that have more capacity.

### New Microsoft licensing model

We are changing the way we charge for Microsoft licenses in OpenStack IaaS to better align with how Microsoft charges for these licenses and to make it more cost effective for high memory instances. Until now we have based the MS server licenses on the amount of instance RAM. The new license model will be based on the number of instance CPUs which also aligns better with how you typically buy these licenses.

| License                     | Current Price              | New Price
|-----------------------------|----------------------------|-------------
| Microsoft Windows Server    | 36.5 SEK / GB RAM / Month  | 189 SEK / CPU / Month
| Microsoft MSSQL Standard    | 197.1 SEK / GB RAM / Month | 1229 SEK / CPU / Month
| Microsoft MSSQL Enterprise  |                            | 4821 SEK / CPU / Month
| Microsoft MSSQL Web Edition |                            | 79 SEK / CPU / Month


You need to license at least 4 CPUs per instance for Microsoft MSSQL server.
MSSQL licenses are billed per month and any usage change needs to be reported to Elastx Support.

The new pricing will apply from 2023-05-01

### New Load Balancer flavors

We have added multiple OpenStack Load Balancer flavors with more capacity to allow more demanding workloads. Until now we have provided a single flavor for all Load Balancers but now you can select a Load Balancer with more capacity if required.


| Load Balancer Flavor  | Price per hour       | Price per month
|-----------------------|----------------------|-------------
| v1-lb-1 (default)     | 0.53 kr              | 386.90 kr
| v1-lb-2               | 1.06 kr              | 773.80 kr
| v1-lb-4               | 2.12 kr              | 1,547.60 kr
| v1-lb-8               | 4.24 kr              | 3,095.20 kr

This is a general guideline on traffic capacity but it can differ based on traffic pattern.

v1-lb-1 approximately 200Mbit<br>
v1-lb-2 approximately 400Mbit<br>
v1-lb-4 approximately 800Mbit<br>
v1-lb-8 approximately 1.6Gbit<br>

The new Load Balancer Flavors are available now.

---

## 2023-01-27 Elastx Cloud Platform pricing adjustment

To Elastx Customers and Partners,<br />
We are trying to avoid a general price increase on all services, even though the current high inflation is affecting us hard. We are investing in new more efficient technology to compensate for the increased cost derived from product vendors, utility services, financial service and internal costs. We have identified a few selected services where we need to perform price adjustments to be able to continue the development in a sustainable way.<br />
The new pricing will apply from 2023-03-01.

 We will adjust the pricing on the dedicated instance flavor d1-c8-m58-d800.

| Flavor         | Current price        | New price           
|----------------|----------------------|-------------
| d1-c8-m58-d800 | 3950 SEK / Month     | 4750 SEK / Month              

We will adjust the pricing on the network Load Balancer as a Service.

| Service                    | Current price        | New price                         
|----------------------------|----------------------|-------------
| Load Balancer as a Service | 250 SEK / Month      | 390 SEK / Month  

---

## 2022-09-30 Openstack encrypted volumes and deprecated flavor


During 2021 we announced that all volumes in OpenStack are encrypted at no additional cost. We are now changing the end of life date of our legacy encrypted volume types. <br /> We are also deprecating our first dedicated instance flavor. No end of life date will be announced today but there will be limited availability as we will not add any additional capacity.

### Encrypted Volumes EOL update
During 2021 we enabled encryption at rest for all volumes in our Openstack IaaS. Prior to this change you could select encryption as an option which cost more than non encrypted volumes. Now all new and existing volumes are encrypted at no additional cost.


There is a function available in OpenStack to migrate data between volume types that can be used to migrate from a legacy encrypted volume to a standard volume type which also is encrypted at rest. We have users requesting to postpone the EOL date and therefore we are now announcing a new EOL date. 


The following volume types are deprecated and will be disabled at the latest 2023-09-30.
- 4k-IOPS-enc
- 8k-IOPS-enc
- 16k-IOPS-enc


**The price for these volume types will increase by 30% 2023-01-01.**


If you are running any of the above volume types you need to migrate the data to other volume types.


When you migrate the legacy encrypted volumes to our standard volumes you will reduce the cost for your volumes. You can change the volume type from a legacy encrypted to a standard volume but it is an offline process.
Please contact support if you need any help or recommendation on how to do this.

### Deprecated dedicated flavor
The following dedicated instance flavor is now deprecated.
- d1-c8-m58-d800
- v1-dedicated-8 (legacy name)


We will not announce an End Of Life date today and when we do it will be announced at least one year ahead. 
We will not add any additional capacity to this flavor so there is limited availability. There can be situations where we do not have any available capacity to start new instances with this flavor.

This is also the only flavor that doesn’t have a boot disk with at rest encryption.

---

## 2022-06-15 Increased price on Openstack d2 instances

### Due to the increased pricing on hardware and power we need to increase the price on d2 instances.

There has been an extreme price increase on hardware and power during the last 6 months which has forced us to increase the price on our OpenStack d2 dedicated instances. Both current and new instances with these flavors will be affected.

The following instances flavors are affected.

| Flavor            | Current price        | New price           
|-------------------|----------------------|-------------
| d2-c8-m120-d1.6k  | 5950 SEK / month     | 6890 SEK / Month              
| d2-c8-m120-d11.6k | 8249 SEK / month     | 9250 SEK / Month

The new prices will apply from 2022-10-01.

<hr>



## 2022-06-14 New OpenStack Instance flavors to better match your workloads.

Elastx is introducing new OpenStack Instance flavors and a new flavor naming standard. The new flavors are memory or cpu optimized flavors that can be used to better match your workload requirements. The new naming standard will make it easier to understand the flavor specification and to support additional flavor types in the future.

### New Flavors

Here are all the new flavors that will be available soon.

| Flavor            | vCPU                 | RAM                  | Disk
|-------------------|----------------------|----------------------|-----
| v1-c1-m8-d60      | 1 CPU                | 8GB RAM              | 60GB SSD Disk
| v1-c2-m4-d60      | 2 CPU                | 4GB RAM              | 60GB SSD Disk
| v1-c2-m16-d120    | 2 CPU                | 16GB RAM             | 120GB SSD Disk
| v1-c4-m8-d120     | 4 CPU                | 8GB RAM              | 120GB SSD Disk
| v1-c4-m32-d240    | 4 CPU                | 32GB RAM             | 240GB SSD Disk
| v1-c8-m16-d240    | 8 CPU                | 16GB RAM             | 240GB SSD Disk
| v1-c8-m64-d480    | 8 CPU                | 64GB RAM             | 480GB SSD Disk


### New naming standard

All flavors will get new names, the current flavors will still be available and new flavors with the new naming standard will be created in parallel. The cost for the new flavors will be the same as the current corresponding one.

Here is how the new naming standard works.

<strong>First character</strong> <br>
v=vm (virtual machine on shared hypervisor)<br>
d=dedicated (virtual machine on dedicated hypervisor)<br>
b=bare metal (bare metal machine)

<strong>First number</strong> <br>
#=hardware version

<strong>The following characters and numbers</strong> <br>
c=vCPU amount <br>
m=Memory in GB <br>
d=disk in GB <br> 
g=gpu and type of GPU <br>
s=sgx enabled and the amount of sgx RAM in GB

<strong>Here are the new naming on the corresponding current flavors</strong>

| Flavor            | vCPU                 | RAM                  | Disk            | Current
|-------------------|----------------------|----------------------|-----------------|---------
| v1-c1-m0.5-d20    | 1 CPU                | 0.5GB RAM            | 20GB SSD Disk   | v1-micro-1
| v1-c1-m1-d20      | 1 CPU                | 1GB RAM              | 20GB SSD Disk   | v1-mini-1
| v1-c1-m2-d20      | 1 CPU                | 2GB RAM              | 20GB SSD Disk   | v1-small-1
| v1-c1-m4-d40      | 1 CPU                | 4GB RAM              | 40GB SSD Disk   | v1-standard-1
| v1-c2-m8-d80      | 2 CPU                | 8GB RAM              | 80GB SSD Disk   | v1-standard-2
| v1-c4-m16-d160    | 4 CPU                | 16GB RAM             | 160GB SSD Disk  | v1-standard-4
| v1-c8-m32-d320    | 8 CPU                | 32GB RAM             | 320GB SSD Disk  | v1-standard-8
| d1-c8-m58-d800    | 8 CPU                | 58GB RAM             | 800GB SSD Disk  | v1-dedicated-8
| d2-c8-m120-d1.6k  | 8 CPU                | 120GB RAM            | 1600GB SSD Disk | v2-dedicated-8
| d2-c8-m120-d11.6k | 8 CPU                | 120GB RAM            | 11600GB SSD Disk | d2-dedicated-8

The new flavors will be available from 2022-06-20.

<hr> 

## 2022-06-13 Reducing OpenStack volume price with up to 63% and increasing performance with up to 50%.

Elastx is introducing a new volume type that will be more cost effective and can also improve performance with up to 50%. We will also adjust the pricing on some of the current volume types with up to 63% without any change in service levels.

Our OpenStack IaaS volumes are based on redundant SSD persistent storage clusters which are available in all our three availability zones. Our storage clusters are battle proven and have been running with predictable performance and without interruption for almost 10 years! During this period we have expanded, made hardware refreshes and enabled encryption, all without disruption.

### New volume type "v1-dynamic-40"

The new volume type is called “v1-dynamic-40”. The performance is dynamic which means iops will be provisioned depending on the size of the volume. There will be a base provisioned iops and then added iops performance for each added GB in size up to a maximum level. The new dynamic volume type will cost less and perform better than the current entry level volume type “4k-IOPS”.
This new volume type and all our current volumes are encrypted at rest. 

<strong>V1-dynamic-40 volume</strong> <br>
Base provisioned iops: 4000 <br>
Additional iops per GB: 40 <br>
Max iops: 24000 <br>
Price per GB: 2.90 SEK/GB/month <br>
Base price per volume: 0 SEK/month <br>

Example, a 400GB volume will have 20000 iops (4000+400*40) and cost 1160 SEK / month.

The new “v1-dynamic-40” volume will be available 2022-06-20.

### Price change on current volumes.

We will adjust the price on our current static iops volumes to be more cost effective and be aligned with the cost to provisioned iops. These static volumes have a higher base provisioned iops and do not increase in iops performance. To match this with the cost we will lower the price per GB and introduce a base cost for the higher base performance.

<strong>8k-IOPS volume </strong> <br>
Base provisioned iops: 8000 <br>
Additional iops per GB: 0 <br>
Max iops: 8000 <br> 
Price: 2.50 SEK/GB/month <br>
Base price per volume: 150 SEK/month

Example, a 100GB volume will have 8000 iops and cost 400 SEK / month (150+100*2.5).

<strong>16k-IOPS volume</strong> <br>
The legacy encrypted volumes are deprecated as all volumes are encrypted now.

Base provisioned iops: 16000 <br>
Additional iops per GB: 0 <br>
Max iops: 16000 <br>
Price: 2.50 SEK/GB/month <br>
Base price per volume: 290 SEK/month

Example, a 100GB volume will have 16000 iops and cost 540 SEK / month (290+100*2.5).

<strong>8k-IOPS-enc volume (deprecated)</strong> <br>
The legacy encrypted volumes are deprecated as all volumes are encrypted now.

Base provisioned iops: 8000 <br>
Additional iops per GB: 0 <br>
Max iops: 8000 <br>
Price: 4.30 SEK/GB/month <br>
Base price per volume: 150 SEK/month

Example, a 100GB volume will have 8000 iops and cost 580 SEK / month (150+100*4.3).

<strong>16k-IOPS-enc volume (deprecated)</strong> <br>
Base provisioned iops: 16000 <br>
Additional iops per GB: 0 <br>
Max iops: 16000 <br>
Price: 4.30 SEK/GB/month <br>
Base price per volume: 290 SEK/month

Example, a 100GB volume will have 16000 iops and cost 720 SEK / month (290+100*4.3).

The new pricing will be applied from 2022-09-01.

### Deprecated volume type
The “4k-IOPS” volume is now deprecated. It will still be available as long as it is in use but we will limit creation of new volumes 2022-12-01. The new volume type v1-dynamic-40 costs less and is faster so we recommend changing current 4k-IOPS volumes to it.

### Changing volume type
The volume type on a current volume can be changed without disruption and the new specifications will be applied instantly. 

<hr>

## 2022-01-17


We are happy to announce that all volumes in OpenStack are now encrypted at no additional cost and we will soon start the upgrade of the OpenStack version with new features and improvements. 

### Encrypted Volumes
Our goal is to provide the best conditions and tools to run applications in a secure and predictable way. During 2021 we enabled encryption at rest for all volumes in our Openstack IaaS. Prior to this change you could select encryption as an option which cost more than non encrypted volumes. Now all new and existing volumes are encrypted at no additional cost.
The option to select encrypted volumes is now obsolete and will be removed shortly.

The following volume types are deprecated and will be disabled 2022-09-30.<br />
4k-IOPS-enc<br />
8k-IOPS-enc<br />
16k-IOPS-enc<br />


If you are running any of the above volume types you need to migrate the data to other volume types.<br />

When you migrate the legacy encrypted volumes to our standard volumes you will reduce the cost for your volumes. You can’t change the volume type from a legacy encrypted to a standard volume, you need to create a new volume and migrate the data.
Please contact support if you need any help or recommendation on how to do this.

### OpenStack IaaS upgrade
We will soon upgrade our OpenStack platform and this will be performed in three steps.
The plan is to start the upgrade in February. We will announce service windows for the upgrade on our status page, https://status.elastx.se. Here you can also subscribe to get notifications about service windows and incidents.

##### Step 1
OpenStack version will be upgraded to Rocky.
There will be disturbance with the OpenStack API but we do not expect any disturbance on running workloads.

##### Step 2
Upgrade operating system on control plane and compute nodes.<br />
<span style="color:red">There will be disruption of workloads during the upgrade</span>. We will upgrade one availability zone at a time.

##### Step 3
OpenStack version will be upgraded to Train.
There will be disturbance with the OpenStack API but we do not expect any disturbance on running workloads.
