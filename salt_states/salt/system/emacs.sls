/root/.emacs:
    file.managed:
        - source: salt://system/emacs.elc
/etc/vim/vimrc:
    file.managed:
        - source: salt://system/vimrc
/etc/emacs/linum.el:
    file.managed:
        - source: salt://system/linum.el

