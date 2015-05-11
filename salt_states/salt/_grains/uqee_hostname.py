import os
def sethostname():
    grains = {}
    grains['hostname'] = os.popen('hostname').read().strip()
    return grains

    
