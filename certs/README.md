# certs

Certificate and key files should be placed in this folder.

The files should follow the naming convention for [nginx-proxy](https://github.com/jwilder/nginx-proxy#ssl-support):
> The certificate and keys should be named after the virtual host with a .crt and .key extension. For example, a container with VIRTUAL_HOST=foo.bar.com should have a foo.bar.com.crt and foo.bar.com.key file in the certs directory.

Follow [StartSSL](https://www.startssl.com/) to create your certificate and key.
Copy the certificate (.crt) and **decrypted** key (.key) to this folder on your server.

Running `script.sh` in this folder should take care of the setup.
The script is written with the free StartSSL Class 1 certificates in mind.
