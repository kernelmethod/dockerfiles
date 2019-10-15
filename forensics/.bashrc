# ~/.bashrc: executed by bash(1) for non-login shells.

cat << EOT
wshand/forensics
Debian-based forensic analysis environment
-------------------------------------------
This container provides a variety of tools for forensic analysis
(review Dockerfile for more information). In addition, you can
connect to it graphically by running a VNC server.

If you want to do this, run the following:

    mkdir ${HOME}/.vnc
    vncpasswd
    openssl req \\
        -x509 \\
        -newkey rsa:4096 \\
        -keyout ${HOME}/.vnc/vnc.key \\
        -out ${HOME}/.vnc/vnc.cert \\
        -days 365 \\
        -subj '/CN=forensics' \\
        -nodes

Then start the server with

    vncserver \\
        -geometry 800x800 \\
        -PasswordFile ${HOME}/.vnc/passwd \\
        -xstartup /etc/vnc/xstartup \\
        -localhost no \\
        -X509Key ${HOME}/.vnc/vnc.key \\
        -X509Cert ${HOME}/.cert/vnc.cert

EOT
