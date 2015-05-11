/mnt/db.bak:
    file.directory:
        - mode: 755
        - makedirs: True
    mount.mounted:
        - device: {{grains['master']}}:/mnt/data
        - fstype: nfs
        - opts:
            - rw
            - tcp
            - intr
/etc/fstab:
    file.append:
        - text: {{grains['master']}}:/mnt/data /mnt/db.bak nfs rw,tcp,intr 0 0