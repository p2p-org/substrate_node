#!/usr/bin/env python3
import os
import sys

def unlink():
    for provider,projects in data.items():
        for project in projects:
            os.chdir(workdir + "/" + provider + "/projects/" + project)
            try:
                os.unlink("main.tf")
            except FileNotFoundError:
                pass
            try:
                os.unlink("locals.tf")
            except FileNotFoundError:
                pass
            try:
                os.unlink("./modules/instance")
            except FileNotFoundError:
                pass
            try:
                os.unlink("./modules/ansible_inventory")
            except FileNotFoundError:
                pass

def link():
    for provider,projects in data.items():
        for project in projects:
            deep = len(project.split('/'))
            count = 0
            path = '../'
            
            while count < deep:
                path += '../'
                count += 1

            os.chdir(workdir + "/" + provider + "/projects/" + project)

            if not os.path.isdir('./modules'):
                os.makedirs('./modules')

            os.symlink(path + "common/main.tf", "./main.tf")
            os.symlink(path + "common/locals.tf", "./locals.tf")
            os.symlink(path + "../modules/instance/", "./modules/instance")
            os.symlink(path + "../../core_modules/ansible_inventory/", "./modules/ansible_inventory")

if __name__ == "__main__":
    workdir = os.getcwd()
    data = {
        "aws": [
            "kusama"
        ],
        "gcp": [
            "kusama"
        ],
        "hetzner": [
            "kusama"
        ],
        "scaleway": [
            "moonriver",
            "compound"
        ]
    }

    unlink()
    link()
