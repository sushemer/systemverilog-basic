# Notes on Bash scripts

This directory contains **Bash scripts** that automate FPGA workflow tasks  
(synthesis, place & route, programming) for the **Tang Nano 9K** and other supported configurations.

The goal is to run commands such as:

- `./scripts/03_synthesize_for_fpga.bash`
- `./scripts/...` (depending on available scripts)

to avoid performing the full Gowin workflow manually.

---

## Origin

This script framework—and many structural ideas used in this repo—comes from the  
**basic-graphics-music** project by **Mr. Panchul**:

- https://github.com/yuri-panchul/basics-graphics-music

In that project, scripts are used to:

- Configure environments  
- Run synthesis, place & route  
- Generate bitstreams  
- Program different FPGA boards  

This repository **reuses and adapts** that workflow for the **Tang Nano 9K**,  
but the original authorship belongs entirely to **Mr. Panchul**  
and the *basic-graphics-music* project.

This README only explains how the scripts are used here.


[The article about these settings.](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail)
[Arguments
against.](https://www.reddit.com/r/commandline/comments/g1vsxk/comment/fniifmk)
[Another idea.](http://redsymbol.net/articles/unofficial-bash-strict-mode)

```
#  set -e           - Exit immediately if a command exits with a non-zero
#                     status.  Note that failing commands in a conditional
#                     statement will not cause an immediate exit.
#
#  set -o pipefail  - Sets the pipeline exit code to zero only if all
#                     commands of the pipeline exit successfully.
#
#  set -u           - Causes the bash shell to treat unset variables as an
#                     error and exit immediately.
#
#  set -x           - Causes bash to print each command before executing it.
#
#  set -E           - Improves handling ERR signals

set -Eeuxo pipefail
```
