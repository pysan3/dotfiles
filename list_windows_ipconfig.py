#!/usr/bin/env python3

import sys
import subprocess as sbpr


def get_configs():
    data = sbpr.Popen(
        'cmd.exe /c "chcp 437 & ipconfig & chcp 65001"',
        stdout=sbpr.PIPE,
        stderr=sbpr.DEVNULL,
        shell=True
    ).communicate()[0]
    data = data.decode('shift-jis').replace('\r', '').replace('\t', '  ').split('\n')
    configs = {}
    current = "ipconfig"
    for s in data:
        if len(s) == 0:
            continue
        elif not s.startswith(' '):
            current = s.rstrip(':')
            configs.setdefault(current, {})
        elif ':' in s:
            key, value = s.split(':', 1)
            key = ' '.join(key.replace('.', '').split()).strip()
            configs[current][key] = value.strip()
    return configs


def get_wsl_ipaddress(configs):
    for k in configs.keys():
        if 'WSL' in k:
            if 'IPv4 Address' in configs[k]:
                return configs[k]['IPv4 Address']


def current_local_connection(configs):
    connect_data = None
    for k in configs.keys():
        if 'Ethernet adapter' in k:
            if configs[k].get('Media State', '') == 'Media disconnected':
                continue
            elif sum(w in k for w in ['VirtualBox', 'Bluetooth', 'vEthernet']):
                continue
            connect_data = configs[k]
            break
        if 'Wi-Fi' in k:
            connect_data = configs[k]
            break
    if connect_data is None:
        return {}
    return connect_data


def get_windows_ipaddress(configs):
    return current_local_connection(configs).get('IPv4 Address')


def get_windows_gateway(configs):
    return current_local_connection(configs).get('Default Gateway')


if __name__ == "__main__":
    configs = get_configs()

    argv = sys.argv[1] if len(sys.argv) >= 2 else None

    if argv == 'display':
        print(get_wsl_ipaddress(configs))
    elif argv == 'windowshost':
        print(get_windows_ipaddress(configs))
    elif argv == 'windowsgateway':
        print(get_windows_gateway(configs))
    else:
        for k, v in configs.items():
            print(k, v)
