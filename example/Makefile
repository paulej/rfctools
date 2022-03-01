#
# Makefile to build Internet Drafts from markdown using mmarc and
# relying on the docker image "paulej/rfctools".
#

SRC  := $(wildcard draft-*.md)
HTML := $(patsubst %.md,%.html,$(SRC))
UID  := $(shell id -u)
GID  := $(shell id -g)
CWD  := $(shell pwd)

# Ensure the xml2rfc cache directory exists locally
IGNORE := $(shell mkdir -p $(HOME)/.cache/xml2rfc)

all: $(HTML)

clean:
	rm -f draft*.xml draft-*.txt draft*.pdf draft-*.html

%.html: %.md
	# Build .txt, .pdf, and .html output
	docker run --rm --user=$(UID):$(GID) -v $(CWD):/rfc -v $(HOME)/.cache/xml2rfc:/var/cache/xml2rfc paulej/rfctools md2rfc $^
