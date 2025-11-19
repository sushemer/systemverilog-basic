# Notes on Bash scripts
Este directorio contiene **scripts en Bash** que automatizan tareas del flujo de trabajo con FPGA   (por ejemplo, síntesis y programación) para la placa **Tang Nano 9K** y otras configuraciones del repo.

La idea es poder ejecutar comandos del estilo:

- ./scripts/03_synthesize_for_fpga.bash
- ./scripts/…  (según los archivos que haya en este directorio)

para evitar repetir manualmente los pasos en Gowin IDE o en la línea de comandos.

---

## Origen

Todo este esquema de scripts, así como la estructura y muchas de las ideas utilizadas aquí,
proviene del proyecto **basic-graphics-music** de **Mr. Panchul**:

- https://github.com/yuri-panchul/basics-graphics-music

En ese proyecto los scripts se usan para:

- Configurar el entorno.
- Ejecutar síntesis, place & route.
- Generar bitstreams y programar distintas placas.

En este repositorio se reutiliza y adapta ese enfoque para la **Tang Nano 9K**,   pero la autoría original del diseño de los scripts es de **Mr. Panchul** y del proyecto   **basic-graphics-music**.  
Este README solo documenta su uso en este contexto, sin reclamar autoría sobre ellos.

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
