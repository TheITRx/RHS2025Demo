#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2017, Red Hat, Inc.
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

DOCUMENTATION = r'''
---

module: wsus_checkin
short_description: Checks in a Windows machine to the configured WSUS settings
description:
    - Checks in a Windows machine to the configured WSUS settings

version_added: "0.0.2"
author: "Jocel Sabellano"

notes:
    - WSUS client settings need to be in place before this module works. 
requirements:
    - Windows
    - Powershell
'''

EXAMPLES = r'''
---
- name: Checkin to WSUS
  tags: wsuscheckin
  guggenheim.windowspatching.wsus_checkin:

'''

RETURN = r'''

'''