# BitsnBytes

A collection of changes for an  HTML dev server.

Through the years i have been working as a php/html developer, i was in need for a quick n dirty development server, with LAMP  to use as a test environment for my work.

Needless to say i have been rebuilding such servers often enough, so this is a repository of monitored changes, things i shouldnt forget to on a new Debian headless installation


## Contents

### README.md
this file
### apache.conf.changes 
Addition/change to /etc/apache2/apache2.conf so that .htaccess files on the webroot of each site are used.

### example-domain.conf
The basic template for /etc/apache2/sites-available/ virtualhost configuration file. This file is basic and for http only.

Using LetsEncrypt certbot will autocreate the ssl version of this file, and also add redirections on this one to only work sites over https.

### htaccess.sample

The most basic form of .htaccess file to put on a dev site. It just prevents visitors from indexing your site, and restricts the usage of index.php as a homepage

### index.html.sample

lol, cause you know, since im backing up all these, why the hell should i write a generic html5 profile.

### post-update

This is a script to put in a bare repo hooks folder. if you put this repository as a origin on your development pc, every change you push , will be automatically updated in the webroot folder, thus giving you the ability to use versioning for coding AND testing your code.


 
### post-installation.sh

Post installation script, to run after deploying new debian VPS. i haven't tested it yet
