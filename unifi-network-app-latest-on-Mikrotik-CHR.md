# Setting Up UniFi Application with MongoDB on MikroTik CHR Using Containers

This guide will walk you through the process of setting up the UniFi Application with MongoDB 4.0 on a MikroTik CHR (Cloud Hosted Router) using containers. The configuration provided is based on RouterOS 7.15.3.

## Prerequisites

- A MikroTik CHR instance with RouterOS version 7.15.3 or higher.
- Basic knowledge of MikroTik RouterOS and container management.
- Access to the MikroTik command-line interface (CLI).

## Step-by-Step Guide

### 1. Setting Up Container Mounts

First, you need to set up the container mounts for MongoDB and UniFi data:

```
/container mounts
add dst=/data/db name=mongodb-data src=/mongo/data
add dst=/config name=unifi-app-data src=/unifi/data
```

### 2. Configuring Network Interfaces

Create a bridge for the containers and virtual Ethernet (veth) interfaces:

```
/interface bridge
add name=dockers

/interface veth
add address=172.17.0.2/16 comment=container-unifi gateway=172.17.0.1 gateway6="" name=veth1
add address=172.17.0.3/16 comment=container-unifi-mongo-db gateway=172.17.0.1 gateway6="" name=veth2
```

### 3. Setting Up Containers

Add the UniFi and MongoDB containers with the necessary environment variables:

```
/container
add envlist=unifi-envs hostname=unifi interface=veth1 mounts=unifi-app-data workdir=/usr/lib/unifi
add hostname=unifi-db interface=veth2 mounts=mongodb-init-script,mongodb-data
```

### 4. Container Configuration

Configure the container settings such as RAM usage and the Docker registry URL:

```
/container config
set ram-high=953.7MiB registry-url=https://registry-1.docker.io tmpdir=disk1/pull
```

### 5. Setting Up Environment Variables

Define the environment variables required for the UniFi application:

```
/container envs
add key=PUID name=unifi-envs value=1000
add key=PGID name=unifi-envs value=1000
add key=TZ name=unifi-envs value=Etc/UTC
add key=MONGO_USER name=unifi-envs value=unifi
add key=MONGO_PASS name=unifi-envs value=password
add key=MONGO_HOST name=unifi-envs value=172.17.0.3
add key=MONGO_PORT name=unifi-envs value=27017
add key=MONGO_DBNAME name=unifidb
add key=MONGO_INITDB_ROOT_USERNAME name=mongo-envs value=root
add key=MONGO_INITDB_ROOT_PASSWORD name=mongo-envs value=password
```

### 6. Adding Bridge Ports

Add the veth interfaces to the bridge:

```
/interface bridge port
add bridge=dockers interface=veth1
add bridge=dockers interface=veth2
```

### 7. Configuring IP Addresses

Assign IP addresses to the bridge interface:

```
/ip address
add address=172.17.0.1/16 interface=dockers network=172.17.0.0
```

### 8. Setting Up DNS

Configure DNS settings to allow remote requests and set DNS servers:

```
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,8.8.8.8

/ip dns static
add address=172.17.0.3 name=unifi-db
```

### 9. Configuring Firewall NAT

Set up NAT rules to forward traffic to the UniFi container:

```
/ip firewall nat
add action=dst-nat chain=dstnat dst-port=8443 in-interface=ether1 protocol=tcp to-addresses=172.17.0.2 to-ports=8443
add action=dst-nat chain=dstnat comment="set inform port" dst-port=8080 in-interface=ether1 protocol=tcp to-addresses=172.17.0.2 to-ports=8080
```

### 10. Creating a Startup Script

Create a script to start the containers automatically on system boot:

```
/system scheduler
add name=containers-startup on-event=containers-startup policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup

/system script
add dont-require-permissions=no name=containers-startup owner=dvalilis policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    ":delay 30s\r\
    \n/container/start 1\r\
    \n:delay 30s\r\
    \n/container/start 0"
```
### 11. Connecting to MongoDB and Creating Database and User

Use the MikroTik shell to access the MongoDB container and set up the database and user.

1. **Access the MongoDB Shell**:

    ```shell
    /container shell 1
    ```

    This command will open a shell session inside the MongoDB container.

2. **Connect to MongoDB**:

    Once inside the MongoDB container, connect to the MongoDB instance using the following command:

    ```shell
    mongo
    ```

3. **Create the Database and User**:

    In the MongoDB shell, run the following commands to create the database and user:

    ```javascript
    use unifidb
    db.createUser({
      user: "unifi",
      pwd: "password",
      roles: [{ role: "readWrite", db: "unifidb" }]
    })
    ```

4. **Exit the MongoDB Shell**:

    ```shell
    exit
    ```

5. **Exit the Container Shell**:

    Press `Ctrl+D` or type `exit` to leave the container shell and return to the MikroTik CLI.

This step ensures that the MongoDB instance is set up with the necessary database and user for the UniFi application to function correctly.

### 12. Start up Things!
Start up the mongodb container give it 30 seconds for first boot, then start up the unifi container. Or restart the CHR. when CHR starts the scripts created on step 9-10 do this exact routine. Afterwards visit your CHRs IP or domain with https://CHR_IP_OR_DOMAIN:8443

## Conclusion

By following the above steps, you will have set up the UniFi Application with MongoDB on your MikroTik CHR using containers. This configuration ensures that both the UniFi controller and MongoDB are properly isolated and can communicate with each other through the specified network interfaces and environment variables. 

For any issues or further customization, refer to the MikroTik RouterOS and Docker documentation.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to contribute or open an issue on the [GitHub repository](https://github.com/[your-repo-lin](https://github.com/doomster/BitsnBytes) if you encounter any problems or have suggestions for improvements.
