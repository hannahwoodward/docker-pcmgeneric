# PCM Generic Docker Image

[Docker](https://www.docker.com/)/[Podman](https://podman.io/) image to install and run a containerised PCM Generic (formerly LMD) on Fedora.

## Useful links

* [PCM Generic wiki](https://lmdz-forge.lmd.jussieu.fr/mediawiki/Planets/index.php/Overview_of_the_Generic_PCM)
* [Example configurations wiki](https://lmdz-forge.lmd.jussieu.fr/mediawiki/Planets/index.php/Other_GCM_Configurations_worth_knowing_about)
* [Downloadable example configurations](https://web.lmd.jussieu.fr/~lmdz/planets/generic/)
* [PCM/LMD publications](https://www-mars.lmd.jussieu.fr/pubplaneto/pub.html)
* [Docker build help](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run help](https://docs.docker.com/engine/reference/commandline/run/)


## Installation & running via published image

* [Install Docker desktop](https://www.docker.com/get-started)
* Ensure Docker desktop is running
* Download published image:

```
docker pull woodwardsh/pcmgeneric:latest
```

* Run container, noting the mounting of local dir `./runs` to container `/home/app/runs` for shared storage of model output:

```
docker run -it --rm --volume=${PWD}:/home/app/runs woodwardsh/pcmgeneric:latest

# Options:
# -it       interactive && TTY (starts shell inside container)
# --rm      delete container on exit
# --volume  mount local directory inside container
# -w PATH   sets working directory inside container
```

### Podman

* Replace `docker` with `podman`, and note additional options to fix permissions on mounted volumes (see [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html)):

```
podman run -it --rm -v ${PWD}/runs:/home/app/runs --security-opt label=disable woodwardsh/pcmgeneric:latest
```


## Installation & running via locally built image

* Clone repo & navigate inside:

```
git clone git@github.com:hannahwoodward/docker-pcmgeneric.git && cd docker-pcmgeneric
```

* Build image from Dockerfile (~15 min):

```
docker build -t pcmgeneric .
```

* Or, if debugging:

```
docker build -t pcmgeneric . --progress=plain --no-cache
```

* Run locally built container:

```
docker run -it --rm -v ${PWD}/runs:/home/app/runs pcmgeneric

# Options:
# -it       interactive && TTY (starts shell inside container)
# --rm      delete container on exit
# -v        mount local directory inside container
# -w PATH   sets working directory inside container
```

### Podman

* Build with similar command, replacing `docker` with `podman`:

```
podman build -t pcmgeneric .
```

* Run, with additional options to fix permissions on mounted volumes (see [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html)):

```
podman run -it --rm -v ${PWD}/runs:/home/app/runs --security-opt label=disable pcmgeneric
```

## Testing

* Start container
* Run `sh test-earth-aqua.sh` (output written to `./runs/bench_earthslab_64x48x20_b38x36`)
* Run `sh test-mars.sh` (uses SOCRATES; output written to `./runs/bench_earlymars_32x32x15_b32x36`)

## Publishing image

```
docker login && docker tag pcmgeneric woodwardsh/pcmgeneric && docker push woodwardsh/pcmgeneric
```
