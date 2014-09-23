Playing with vagrant packer, docker and ansible
===============================================

TODO: re-implement ansible

Start the vagrant vm
--------------------
The fedora war has to be put into .provision/fedora4

    $ vagrant up
    $ vagrant ssh


Build the docker container with packer
--------------------------------------
Then, on the vm:

    $ packer build /vagrant/.provision/fedora4/pack.json

Run the container
-----------------
To have a look at whether the docker image was created sucessfully:

    $ docker images
    REPOSITORY          TAG                           IMAGE ID            CREATED             VIRTUAL SIZE
    fedora4             basic-fedora-war-served       e2b12b2081bb        6 minutes ago       732.1 MB

Run it with the proccess we want to start:

    $ docker run -d --net=host fedora4:basic-fedora-war-served /usr/local/bin/run_fcrepo

Work with the container
-----------------------
To do sth with the the running container it's good to find out its name

    $ docker ps -l
    ONTAINER ID        IMAGE                             COMMAND                CREATED             STATUS              PORTS               NAMES
    b29a2880cf80        fedora4:basic-fedora-war-served   "/usr/local/bin/run_   17 seconds ago      Up 15 seconds                           berserk_engelbart

Now you can follow the jetty logs (same effect as tail -f) like this:

    $ docker logs -f berserk_engelbart

Use the web interface
---------------------
Once the jetty server has started up, you can access it from within a browser
of your outermost host environment at localhost:8080
