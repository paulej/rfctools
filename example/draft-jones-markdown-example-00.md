%%%

    #
    # Example Markdown Draft
    # (draft-jones-markdown-example)
    #
    # Generation tool chain:
    #   mmark (https://github.com/miekg/mmark)
    #   xml2rfc (http://xml2rfc.ietf.org/)
    #

    Title = "Example Markdown Draft"
    abbrev = "Markdown Example"
    category = "std"
    docName = "draft-jones-markdown-example-00"
    ipr= "trust200902"
    area = "Internet"
    keyword = ["Markdown", "mmark", "rfc", "rfctools"]

    [pi]
    subcompact = "yes"

    [[author]]
    initials = "P."
    surname = "Jones"
    fullname = "Paul E. Jones"
    organization = "Packetizer, Inc."
    abbrev = "Packetizer"
      [author.address]
      email = "paulej@packetizer.com"
      phone = "+1 919 647 9450"
      [author.address.postal]
      street = "5448 Apex Peakway #121"
      city = "Apex"
      region = "North Carolina"
      code = "27502"
      country = "USA"

    #
    # Revision History
    #   00 - Initial draft.
    #

%%%

.# Abstract

This document serves as an example markdown document for use with mmark
and the rfctools docker container.

{mainmatter}

# Introduction

Since installing and configuring both xml2rfc and mmark can require
a bit of head scratching and the process is easily forgotten after a
span of months when a new update is available, the xmltools docker
container can help make like a little easier.

This file is an example of how to use that container.

# Conventions Used In This Document

The key words "**MUST**", "**MUST NOT**", "**REQUIRED**", "**SHALL**",
"**SHALL NOT**", "**SHOULD**", "**SHOULD NOT**", "**RECOMMENDED**",
"**MAY**", and "**OPTIONAL**" in this document are to be interpreted as
described in [@!RFC2119] when they appear in ALL CAPS.  These words may
also appear in this document in lower case as plain English words,
absent their normative meanings.

# More on the Topic

There really are no other things to put into the example document.

# IANA Considerations

IANA is entirely off the hook on this one.

# Security Considerations

Security was not a consideration at all in writing this draft.

# Acknowledgments

I would like to thank the creator of mmark, Miek Gieben, for his invaluable
contribution to make life a lot easier writing RFCs.

{backmatter}
