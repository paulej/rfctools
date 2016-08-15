# RFC Tools

This repository builds a docker image that has various tools for creating Internet Drafts.  In the current release, both the xml2rfc and mmark tools are available when running docker against this image.

You can grab the pre-build docker image from Docker Hub or build it using the Dockerfile here.  The image in Docker Hub is named
"paulej/rfctools".

# Executing Commands

To execute xml2rfc, run docker using a command like this from the directory from which your source XML file is located:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -w /rfc paulej/rfctools xml2rfc --text draft-jones-example-00.xml -o draft-jones-example-00.txt
```

That will run docker using your user ID and group ID (so file ownership is what you would expect), and build the specified draft from your current working directory.  The --rm will delete the docker container once execution completes, since it will not be needed any longer.

Using mmark is a two-step process where mmark is run initially and then xml2rfc is invoked.  To invoke mmark, one would do something like this:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -w /rfc paulej/rfctools mmark -xml2 -page draft-jones-example-00.md draft-jones-example-00.xml
```

You would then run xml2rfc as shown previously.

To make it easier, there is a script called "md2rfc" that will execute both commands with a single invocation.  It is called like this:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -w /rfc paulej/rfctools md2rfc draft-jones-example-00.md
```

Since these commands are lengthy, it is perhaps best to use them in conjunction with a Makefile.  An example Makefile is provided in the "example" directory.

# Cache files for xml2rfc

Cached xml2rfc files are stored in /var/cache/xml2rfc/, but those will be discarded each time "docker run" completes.  To get the benefits of caching, you might consider mapping your local cache directory like this:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -v $HOME/.cache/xml2rfc:/var/cache/xml2rfc -w /rfc paulej/rfctools md2rfc draft-jones-example-00.md
```

Another option might be to place the cache directory in the same directory where your source files are located.  For example, this would work:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -v $(pwd)/.cache-xml2rfc:/var/cache/xml2rfc -w /rfc paulej/rfctools md2rfc draft-jones-example-00.md
```

The example Makefile opts for the first approach to get the benefits of using the cache with multiple different drafts that might be located in different directories or repositories.
