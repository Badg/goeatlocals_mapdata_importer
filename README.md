# Quick disclaimer

If you're reading this, you happened to stumble upon (or, hopefully, were linked to)
a repository in an **extremely** work-in-progress state, during a brief window in which
it was available publicly, for reasons I'm not going to publicly state on github.

Please note: unless explicitly commented otherwise, I wrote all of this code, it
has no license, and all rights are reserved. It is probably
broken, it is littered with to-do's, and it was never intended to see the light of
day in this state. But again, *reasons*.

Inside ``.taetime`` you'll find some infra-as-code terraform files. These are invoked
by my own (custom) dev environment, prepopulating a bunch of stuff to avoid boilerplate.
The rest of the source is approximately what you'd expect, though the packaging system
for python code is a bit opaque, which also has to do with my dev environment. Rest
assured I have both a package spec and a lockfile, they just may or may not show up in
the repo.

# goeatlocals_mapdata_importer

## Quasistatic imports

Quasistatic imports are things that happen only very rarely -- for example, coastline changes, landmass changes, country borders, etc.

## Dynamic imports

Dynamic imports are things that change much more frequently -- for example, buildings, addresses, points of interest, and even things like roads.
