#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2017, Red Hat, Inc.
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

DOCUMENTATION = r'''
--- 
author: 
  - Jocel.Sabellano (@Jocel.Sabellano)
description: 
  - Add a direct membership rule to a device collection.
  - Remove a direct membership rule from a device collection.
short_description: Manages a computer object in WSUS
  
module: devicecollectiondirectmembershiprule
options: 
  computername: 
    description: 
    - Device or computer name to be added to device collection
    required: true
    type: str
  collectionName: 
    description: 
      - Device Collection name where the device/computer will be added
    required: true
    type: str
    choices:
    - absent
    - present
  state: 
    description: 
    - absent --> Removes the membership rule
    - present --> Adds the direct membership rule
    required: true
    type: str

'''

EXAMPLES = r'''
--- 
- name: Add to device collection
  mynamespace.sccm.devicecollectiondirectmembershiprule:
    computername: IL1IGNOREME004
    collectionName: DCL_CFB_SEC_ALL_ALL_ALL_ALL_Server Hardening_2019_Remediate
    state: present

- name: Remove from device collection
  mynamespace.sccm.devicecollectiondirectmembershiprule:
    computername: IL1IGNOREME004
    collectionName: DCL_CFB_SEC_ALL_ALL_ALL_ALL_Server Hardening_2019_Remediate
    state: absent

'''

RETURN = r'''
---
collection_id:
  description:
    - Device Collection ID if found
  type: str

computer_resource_id:
  description:
    - Resource ID of the device/computer resource
  type: str

command_output:
  description:
    - Message returned after command execution
  type: str

'''