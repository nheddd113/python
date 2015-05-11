import os
def version():
    grains = {}
    path = "/home/soidc/wly_web/config/version"
    if  not os.path.exists(path):
        grains['webverion'] = False
        return grains
    content = open(path,"r").readlines()
    for line in content:
        if line.startswith('version'):
            version = line.split('=')[1].strip()
            grains['webversion'] = version
    return grains
