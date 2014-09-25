Playing with vagrant, docker and ansible
===============================================

Basic concept
-------------
We are cloning and building fedora4 on the host(-vagrant-)vm, then
we deploy the necessary bits to a docker container. This approach
can nicely be integrated with other containers and the container
itself stays as lightweight as possible.

Start the vagrant vm
--------------------
The fedora war has to be put into .provision/fedora4

    $ vagrant up
    $ vagrant ssh

Set up the host environment
---------------------------
(1) First we install java and maven on the host machine
    $ ansible-playbook -i /vagrant/ansible/inventory /vagrant/ansible/prepare_host_build_env.yml --connection=local
(2) Then we clone the fedora4 repository and build it with maven
    $ ansible-playbook -i /vagrant/ansible/inventory /vagrant/ansible/get_and_build_fedora4.yml --connection=local
TODO: have set maven to skip tests, think it's AGAIN a proxy issue (fails in HTTP API module), this has to be changed
      on a non-proxy environment)


Build the docker container
--------------------------
There's an ansible var set in the fedora4 role to have everything to be copied to the docker container
in /usr/local/scape/fedora4/export/, this can be changed but has then to be adapted here:
    $ docker build -t="fcrepo4:version-x" /usr/local/scape/fedora4/export/

Run the container
-----------------
To have a look at whether the docker image was created sucessfully:

    $ docker images
    REPOSITORY          TAG             IMAGE ID            CREATED             VIRTUAL SIZE
    fedora4             version-x       e2b12b2081bb        6 minutes ago       732.1 MB

Run it with the proccess we want to start:

    $ docker run -d --net=host fedora4:version-x /usr/local/bin/run_fcrepo

Work with the container
-----------------------
To do sth with the the running container it's good to find out its name

    $ docker ps -l
    ONTAINER ID        IMAGE                COMMAND                CREATED             STATUS              PORTS               NAMES
    b29a2880cf80        fedora4:version-x   "/usr/local/bin/run_   17 seconds ago      Up 15 seconds                           berserk_engelbart

Now you can follow the jetty logs (same effect as tail -f) like this:

    $ docker logs -f berserk_engelbart

Use the web interface
---------------------
Once the jetty server has started up, you can access it from within a browser
of your outermost host environment at localhost:8080
