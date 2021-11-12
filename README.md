# Quick disclaimer

If you're reading this, you happened to stumble upon (or, hopefully, were linked to)
a repository in an **extremely** work-in-progress state, something that I never really
intended to upload publicly. It's part exploration, part prototyping, part creation for
creation's sake. In other words, it's a personal project! That context colors pretty much
every decision made here.

**Important:** much of this repository is approximately off-the-shelf (with slight
modifications or configurations) from the import pipeline used by the
[OpenMapTiles](https://github.com/openmaptiles/openmaptiles) project, by way of
[OpenMapTiles tools](https://github.com/openmaptiles/openmaptiles-tools). Since it
is a derivative of generated code, to be completely honest, I'm not entirely sure
what the licensing situation looks like, so I would assume it follows the dual
licensing format
[described by the project here](https://github.com/openmaptiles/openmaptiles/blob/master/LICENSE.md).

Inside ``.taetime`` you'll find some infra-as-code terraform files. Unfortunately,
these won't be able to run outside of my development environment, as they use some
non-public scripts to wrap boilerplate.

# goeatlocals_mapdata_importer

## Quasistatic imports

Quasistatic imports are things that happen only very rarely -- for example, coastline changes, landmass changes, country borders, etc.

## Dynamic imports

Dynamic imports are things that change much more frequently -- for example, buildings, addresses, points of interest, and even things like roads.
