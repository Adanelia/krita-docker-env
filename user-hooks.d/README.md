You can add any scripts into this folder to perform any user-side
initialization of the contaner. The scripts will be executed in the 
context of the host system **before** starting the container.

For example, you can add a script to mount your shared persistent 
directory into the persistent location of this container before the
container is run:

```bash
# create the script

cat <<EOF > 00_mount_shared_persistent_folder
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
PROJECTDIR=\$(realpath "\$DIR/../")
mkdir -p \$PROJECTDIR/persistent
sudo mount --bind /path/to/shared \$PROJECTDIR/persistent
EOF

# don't forget to make it executable

chmod a+x 00_mount_shared_persistent_folder

```

Now every time you start the container, your shared persistent directory 
will be automatically mounted.