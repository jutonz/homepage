My Elixir + Phoenix homepage, as deployed via [Kubernetes](kubernetes.io).

### Getting started

#### 1. Install Docker
The development environment uses [Docker](https://www.docker.com/what-docker). This allows entire devleopment environments to be prebuilt and uploaded to the cloud. All you have to do is download the prebuilt images to your local machine and run them. Not bad, right?

First, install Docker by following the instructions for [Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac), [Linux](https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository), or [Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows).

You'll also need Docker Compose, which is a convenient way to manage the several Docker containers required to run the app. We're using it here instead of [Foreman](https://github.com/ddollar/foreman), which you may be familiar with if you've done this Rails thing before. Mac and Windows users get Compose automatically with the Docker desktop kits, but Linux users will have to install it separately by running the following commands:

```bash
# Again, this is only necessary for Linux users
$ curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose

# This should return 1.13.0
$ docker-compose --version
```

#### 2. Install the CLI
There is a [Thor](http://whatisthor.com/)-based CLI which wraps most relevant Docker commands so you don't have to remember all the flags and switches. Since it runs on your local machine, you'll have to install Ruby and a few gems locally to use it:

```bash
$ gem install bundler
$ bundle install --gemfile Gemfile.cli
```

#### 3. Pull images and setup the database

Download the prebuilt images to your local machine:

```bash
thor docker:pull
```

To allow database content to be persisted when the database image is destroyed, it must be saved on your local machine. Run this command to setup the database directories locally (this is a one-time thing--you won't have to do this again on your current machine).

```bash
thor docker:initdb
```

#### 4. Finally, start the app
Almost there! Just run this command and you're up and running

```bash
thor docker:up
```

You should be able to visit [localhost:4000](localhost:4000) and see the app.
