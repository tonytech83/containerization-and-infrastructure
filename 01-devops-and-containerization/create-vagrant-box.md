### 1. **Create the Virtual Machine in VirtualBox**

1. Open **VirtualBox** and create a new VM:
    - Name: `Debian-12.9`
    - Type: `Linux`
    - Version: `Debian (64-bit)`
    - Memory: At least 1024 MB (recommended: 2048 MB).
    - Disk: Create a dynamically allocated disk, at least 10 GB.
    
2. Attach the `debian-12.9.0-amd64-netinst.iso`:
    - Go to **Settings** > **Storage**.
    - Under **Controller: IDE**, add the ISO as an optical disk.
    
3. Configure the network:
    - Use **NAT** for the first adapter.
    - Add a second network adapter as **Host-Only Adapter**.
    
4. Start the VM and proceed with the Debian installation:
    - During the installation:
        - Choose a minimal installation without a GUI.
        - Set up a user (`vagrant`) and a password (`vagrant`).
        - Set the hostname to `debian`.
        - Configure the disk and finish the installation.
        
### 2. **Prepare the VM for Vagrant**

Once the VM is installed, boot into the system and configure it for Vagrant.
#### Log in to the VM:

- Username: `vagrant`
- Password: `vagrant`

#### Install VirtualBox Guest Additions:

1. Install `sudo` and add vagrant in sudoers group.
```sh
su - root
apt-get install sudo

usermod -aG sudo vagrant
exit
```

2. Install required packages
```sh
sudo apt update
sudo apt install -y build-essential curl dkms linux-headers-$(uname -r)
```
2. Insert the VirtualBox Guest Additions ISO:
- In VirtualBox, go to **Devices > Insert Guest Additions CD Image**.
3. Mount the CD:
```sh
sudo mount /dev/cdrom /mnt
```
4. Run the installer:
```
sh /mnt/VBoxLinuxAdditions.run
```
5. Reboot the VM:
```sh
reboot
```
#### Create the `vagrant` User's SSH Configuration:

1. Add the Vagrant public key to the `vagrant` user:
```sh
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
curl -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
```
2. Disable the password prompt for `vagrant` using `sudo`:
```sh
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vagrant
sudo chmod 440 /etc/sudoers.d/vagrant
```
#### Clean Up the VM:

1. Remove unnecessary packages:
```sh
sudo apt autoremove -y
sudo apt clean
```
2. Zero out free space to reduce the box size:
```sh
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
```
3. Shutdown the VM:
```sh
sudo shutdown -h now
```

### 3. **Package the VM as a Vagrant Box**

1. In your host machine, package the VM using `vagrant package`:
```sh
vagrant package --base Debian-12-9 --output debian-12-9.box
```
2. The `--base` option should match the name of the VirtualBox VM.

### 4. **Test the Box Locally**

1. Add the new box to Vagrant:
```sh
vagrant box add debian-12-9 ./debian-12-9.box
```
2. Initialize and test it:
```sh
mkdir test-box
cd test-box
vagrant init debian-12.9
vagrant up
```

### 5. **Upload the Box to Vagrant Cloud**

1. Log in to Vagrant Cloud:
```sh
hcp auth login

# Get the token value first
$token = $(hcp auth print-access-token)

# Save it permanently for your user
[Environment]::SetEnvironmentVariable("VAGRANT_CLOUD_TOKEN", $token, [EnvironmentVariableTarget]::User)
```
2. Create a new box on Vagrant Cloud or using the CLI:
```sh
vagrant cloud publish USERNAME/debian-12.9 1.0.0 virtualbox ./debian-12.9.box \
    --description "Debian 12.9 minimal Vagrant box" \
    --short-description "Debian 12.9 base box" \
    --release
```
3. Replace `USERNAME` with your Vagrant Cloud username.
