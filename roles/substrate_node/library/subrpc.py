#!/usr/bin/env python3

from ansible.module_utils.basic import *
import requests
import json 
import time

def rpc_request(url,method):
    headers = {"Content-Type":"application/json"}
    data = {"id":1, "jsonrpc":"2.0","method":method}

    return requests.post(url,data=json.dumps(data),headers=headers).json()['result']

def sync_state(data):
    if data['currentBlock'] == data['highestBlock']:
        return {"status": "success", "currentBlock": data['currentBlock'], "highestBlock": data['highestBlock']}
    else:
        return {"status": "failed"}

def finality_state(rpc_url,retries,delay):
    count = 0
    heads = []
    unique = []

    while count < retries:
        block = rpc_request(rpc_url,"chain_getFinalizedHead")
        heads.append(block)
        count += 1
        time.sleep(delay) 
    
    for i in heads:
        if i not in unique:
            unique.append(i)

    if len(unique) == retries:
        status = "success"
    else:
        status = "failed"

    return {"retries": retries, "delay": delay, "heads": heads, "status": status}

def main():
    fields = {
        "action": {"required": True, "type": "str", "choices": ['check_sync', 'check_finality']},
        "rpc_url": {"required": True, "type": "str"},
	"retries": {"required": False, "type": "int"},
	"delay": {"required": False, "type": "int" }
}

    module = AnsibleModule(argument_spec=fields)

    if module.params['action'] == "check_sync":
        r = sync_state(rpc_request(module.params['rpc_url'],"system_syncState"))
    elif module.params['action'] == "check_finality":
        r = finality_state(module.params['rpc_url'],module.params['retries'],module.params['delay'])

    module.exit_json(changed=False, result=r)

if __name__ == '__main__':
    main()
