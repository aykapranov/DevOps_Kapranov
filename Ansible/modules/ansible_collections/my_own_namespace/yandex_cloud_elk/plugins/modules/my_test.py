#!/usr/bin/python

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.module_utils.basic import AnsibleModule
import os

DOCUMENTATION = r'''
---
module: my_test
short_description: Create a file with specified content
version_added: "1.0.0"
description: Creates a text file on the target machine with given content.
options:
    path:
        description: Path to the file to be created.
        required: true
        type: str
    content:
        description: Content to write into the file.
        required: true
        type: str
author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
- name: Create a test file
  my_namespace.my_collection.my_test:
    path: /tmp/testfile.txt
    content: Hello from my module!
'''

RETURN = r'''
path:
    description: Path where the file was created.
    type: str
    returned: always
    sample: '/tmp/testfile.txt'
changed:
    description: Whether the file was created or modified.
    type: bool
    returned: always
'''

def run_module():
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    result = dict(
        changed=False,
        path='',
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    path = module.params['path']
    content = module.params['content']

    result['path'] = path

    if module.check_mode:
        module.exit_json(**result)

    # Проверим, существует ли файл и отличается ли содержимое
    file_exists = os.path.exists(path)
    old_content = None

    if file_exists:
        try:
            with open(path, 'r') as f:
                old_content = f.read()
        except Exception:
            pass

    if not file_exists or old_content != content:
        try:
            with open(path, 'w') as f:
                f.write(content)
            result['changed'] = True
        except Exception as e:
            module.fail_json(msg=f"Failed to write file: {e}", **result)

    module.exit_json(**result)

def main():
    run_module()

if __name__ == '__main__':
    main()
