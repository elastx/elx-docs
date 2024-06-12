---
title: "Auto Heling"
description: "Automatic Healing for Unresponsive or Failed Kubernetes Nodes"
weight: 5
alwaysopen: true
---

In our Kubernetes Services, we have implemented a robust auto-healing mechanism to ensure the high availability and reliability of our infrastructure. This system is designed to automatically manage and replace unhealthy nodes, thereby minimizing downtime and maintaining the stability of our services.

## Auto-Healing Mechanism

### Triggers

1. **Unready Node Detection**:
   - The auto-healing process is triggered when a node remains in an "not ready" or "unknown" state for 15 minutes.
   - This delay allows for transient issues to resolve themselves without unnecessary node replacements.

2. **Node Creation Failure**:
   - To ensure new nodes are given adequate time to initialize and join the cluster, we have configured startup timers:
     - **Control Plane Nodes**:
       - A new control plane node has a maximum startup time of 30 minutes. This extended period accounts for the critical nature and complexity of control plane operations.
     - **Worker Nodes**:
       - A new worker node has a maximum startup time of 10 minutes, reflecting the relatively simpler setup process compared to control plane nodes.

### Actions

1. **Unresponsive Node**:
   - Once a node is identified as unready for the specified duration, the auto-healing system deletes the old node.
   - Simultaneously, it initiates the creation of a new node to take its place, ensuring the cluster remains properly sized and functional.

## Built-in Failsafe

To prevent cascading failures and to handle scenarios where multiple nodes become unresponsive, we have a built-in failsafe mechanism:

- **Threshold for Unresponsive Nodes**:
  - If more than 35% of the nodes in the cluster become unresponsive simultaneously, the failsafe activates.
  - This failsafe blocks any further changes, as such a widespread issue likely indicates a broader underlying problem, such as network or platform-related issues, rather than isolated node failures.

By integrating these features, our Kubernetes Services can automatically handle node failures and maintain high availability, while also providing safeguards against systemic issues. This auto-healing capability ensures that our infrastructure remains resilient, responsive, and capable of supporting continuous service delivery.
