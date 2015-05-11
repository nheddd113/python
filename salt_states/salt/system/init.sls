include:
    - .remove
    - .pkgrepo
    - .mount
    - .system
    - .packages
    - .updategrains
    - .ssh
    - .emacs

install_system:
    grains.present:
        - value: True
