# RFC Tools

This repository builds a docker image that has various tools for creating Internet Drafts.  In the current release, both the xml2rfc and mmark tools are available when running docker against this image.

You can grab the pre-built docker image from Docker Hub or build it using the Dockerfile here.  The image in Docker Hub is named "paulej/rfctools".

# Executing Commands

Using mmark is a two-step process where mmark is run initially and then xml2rfc is invoked.  To invoke mmark, one would do something like this:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -w /rfc paulej/rfctools mmark -xml2 -page draft-jones-markdown-example-00.md draft-jones-markdown-example-00.xml
```

That will run docker using your user ID and group ID (so file ownership is what you would expect), and build the specified draft from your current working directory.  The --rm will delete the docker container once execution completes, since it will not be needed any longer.

Before using xml2rfc, we need a place to store cache files used by xml2rfc.  Typically, those are stored in $HOME/.cache/xml2rfc or /var/cache/xml2rfc.  We'll store the cache files in the directory $HOME/.cache/xml2rfc, but map that to the docker container's directory /var/cache/xml2rfc.  To do that, first ensure the $HOME/.cache/xml2rc directory exists:

```
    $ mkdir -p $HOME/.cache/xml2rfc
```

To execute xml2rfc, run docker using a command like this from the directory from which your source XML file is located:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -v $HOME/.cache/xml2rfc:/var/cache/xml2rfc -w /rfc paulej/rfctools xml2rfc --text draft-jones-markdown-example-00.xml -o draft-jones-markdown-example-00.txt
```

To make it easier, there is a script called "md2rfc" that will execute both commands with a single invocation.  However, to give you flexibility in where you store xml2rfc cache files, the script will not create the cache directory.  Be sure to do that beforehand.  The "md2rfc" script is called like this:

```
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -v $HOME/.cache/xml2rfc:/var/cache/xml2rfc -w /rfc paulej/rfctools md2rfc draft-jones-markdown-example-00.md
```

Since these commands are lengthy, it is perhaps best to put them in a Makefile.  An example Makefile is provided in the "example" directory.

# Cache files for xml2rfc

As noted in the previous section, cached xml2rfc files are stored in /var/cache/xml2rfc/ when run inside the docker container, which is mapped to $HOME/.cache/xml2rfc on the local file system.  Without mapping the local filesystem's cache directory via the -w switch, any cache files created would be discarded each time "docker run" completes.

As an alternative to mapping $HOME/.cache/xml2rfc, one might place the cache directory in the same directory where your source files are located.  For example, one could create a directory called ".cache-xml2rfc" in the current directory and invoke a slightly modified command:

```
  $ mkdir .cache-xml2rfc
  $ docker run --rm --user=$(id -u):$(id -g) -v $(pwd):/rfc -v $(pwd)/.cache-xml2rfc:/var/cache/xml2rfc -w /rfc paulej/rfctools md2rfc draft-jones-markdown-example-00.md
```

The cache directory can be placed anywhere.  The only important consideration is to ensure that the cache directory is accessible whenever invoking xml2rfc, mapping whatever chosen directory to /var/cache/xml2rfc in the docker container.

# Example with a Makefile

As noted above, in the "example" directory there is a Makefile that will create the $HOME/.cache/xml2fc directory and then run the "md2rfc" script inside a running docker container.  You can place any number of .md files in the directory with this Makefile and it will build all of them.  It was intended to highlight just how easy it is to use docker to invoke mmark and xml2rfc via the docker container.  Feel free to modify that Makefile to meet your particular needs.
