<!--
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

<!--
    Copyright (c) 2014, Joyent, Inc.
-->

# manta-wrasse

This repository is part of the Joyent Manta project.  For contribution
guidelines, issues, and general documentation, visit the main
[Manta](http://github.com/joyent/manta) project page.

This repo contains `mantamon`, which is the administrative tool that manages
operational bits for Manta.  You should be familiar with Amon already, so if
you're not, go get familar.

This tool is installed in each datacenter where Manta is running, and manages
probes/alarms for that datacenter.

There is full documentation installed with it as a manpage, so in a manta
deployment zone just do `man mantamon`.

However, if you're an engineer and want to define additional probes for manta,
read on.

# Probes

All probe files are stored by role under `/probes`.  In addition there is a
`common` directory that *all* roles will also pull in (the exception being
`compute`, which does not pull those in).

The probe files themselves are just JSON blobs that match what Amon wants,
minus the `agent` bit.  If you want a probe to run in the GZ of a service's
zone, just set the field `global: true` in the JSON blob (this is not an
Amon thing, but mantamon figures it out for you).
