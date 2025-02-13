---
title: "Change PV StorageClass"
description: "How to migrate between storage classes"
weight: 5
alwaysopen: true
---

This guide details all steps to change storage class of a volume. The instruction can be used to migrate from one storage class to another, while retaining data. For example from `8k`to `v2-4k`.


### Prerequisites
* Access to the kubernetes cluster
* Access to Openstack kubernetes Project


## Preparation steps


1. Populate variables

    Complete with relevant names for your setup. Then copy/paste them into the terminal to set them as environment variables that will be used throughout the guide.
    PVC is the 

    ```code
    PVC=test1
    NAMESPACE=default
    NEWSTORAGECLASS=v2-1k
    ```

1. Fetch and populate the PV name by running:

    ```code
    PV=$(kubectl get pvc -n $NAMESPACE $PVC -o go-template='{{.spec.volumeName}}')
    ```

1. Create backup of PVC and PV configurations

   Fetch the PVC and PV configurations and store in /tmp/ for later use:

    ```code 
    kubectl get pvc -n $NAMESPACE $PVC -o yaml | tee /tmp/pvc.yaml
    kubectl get pv  $PV -o yaml | tee /tmp/pv.yaml
    ```

1. Change _VolumeReclaimPolicy_ 

    To avoid deletion of the PV when deleting the PVC, the volume needs to have _VolumeReclaimPolicy_  set to _Retain_.

    Patch:

    ```code
    kubectl patch pv $PV -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
    ```


1. Stop pods from accessing the mounted volume (ie kill pods/scale statefulset/etc..).


1. Delete the PVC.


    ```code
    kubectl delete pvc -n "$NAMESPACE" "$PVC"
    ```


## Login to Openstack


1. Navigate to: Volumes -> Volumes


1. Make a backup of the volume
    From the drop-down to the right, select backup. The backup is good practice, not used in the following steps.


1. Change the _storage type_ to desired type.
    The volume should now or shortly have status _Available_.
    Dropdown to the right, Edit volume -> Change volume type:

    * Select your desired _storage type_
    * Select _Migration policy=Ondemand_
    
    The window will close, and the volume will be updated and migrated (to the v2 storage platform) if necessary, by the backend. The status becomes "Volume retyping". Wait until completed. 
    
    We have a complementary guide [here](https://docs.elastx.cloud/docs/openstack-iaas/guides/volume_retype/).


## Back to kubernetes


1. Release the tie between PVC and PV

    The PV is still referencing its old PVC, in the `claimRef`, found under _spec.claimRef.uid_.
    This UID needs to be nullified to release the PV, allowing it to be adopted by a PVC with correct storageClass.

    Patch _claimRef_ to null:

    ```code
    kubectl patch pv "$PV" -p '{"spec":{"claimRef":{"namespace":"'$NAMESPACE'","name":"'$PVC'","uid":null}}}'
    ```


1. The PV StorageClass in kubernetes does not match to its counterpart in Openstack.

    We need to patch the storageClassName reference in the PV:

    ```code
    kubectl patch pv "$PV" -p '{"spec":{"storageClassName":"'$NEWSTORAGECLASS'"}}'
    ```


1. Prepare a new PVC with the updated storageClass

    We need to modify the saved _/tmp/pvc.yaml_.
       
    1. Remove "last-applied-configuration":  

        ```code
        sed -i '/kubectl.kubernetes.io\/last-applied-configuration: |/ { N; d; }' /tmp/pvc.yaml
        ```

    1. Update existing storageClassName to the new one:

        ```code
        sed -i 's/storageClassName: .*/storageClassName: '$NEWSTORAGECLASS'/g' /tmp/pvc.yaml
        ```

1. Apply the updated _/tmp/pvc.yaml_

    ```code
    kubectl apply -f /tmp/pvc.yaml
    ```

1. Update the PV to bind with the new PVC

    We must allow the new PVC to bind correctly to the old PV. We need to first fetch the new PVC UID, then patch the PV with the PVC UID so kubernetes understands what PVC the PV belongs to.    

    1. Retrieve the new PVC UID:

        ```code
        PVCUID=$(kubectl get -n "$NAMESPACE" pvc "$PVC" -o custom-columns=UID:.metadata.uid --no-headers)
        ```


    1. Patch the PV with the new UID of the PVC:
        
        ```code
        kubectl patch pv "$PV" -p '{"spec":{"claimRef":{"uid":"'$PVCUID'"}}}'
        ```


1. Reset the _Reclaim Policy_ of the volume to _Delete_:

    ```code
    kubectl patch pv $PV -p '{"spec":{"persistentVolumeReclaimPolicy":"Delete"}}'
    ```

1. Completed.

    * Verify the volume works healthily.
    * Update your manifests to reflect the new _storageClassName_.

