# Plantilla LaTeX para tesis

Plantilla para automatizar las entregas escritas de una tesis con LaTeX. Incluye manuscrito, plan de tesis, filminas de avance, filminas de defensa e indice comentado generado desde los capitulos del manuscrito.

## Estructura

- `config/metadata.tex`: datos visibles en los documentos.
- `config/metadata.mk`: datos usados para nombrar los PDFs generados.
- `manuscrito/`: tesis completa.
- `plan_tesis/`: plan o propuesta inicial.
- `filminas_avances/`: presentacion de avances.
- `filminas_defensa/`: presentacion de defensa.
- `indice_comentado/`: reporte generado desde `\chapter`, `\section`, `\subsection` y `\comentario{}` del manuscrito.
- `docker/latex/`: imagen reproducible para compilar localmente o en GitHub Actions.
- `scripts/03_build/`: scripts auxiliares de compilacion.

## Crear una tesis nueva

1. Crear un repositorio nuevo en GitHub usando este proyecto como template.
2. Editar `config/metadata.tex` con titulo, autor, direccion, codireccion, institucion y fecha.
3. Editar `config/metadata.mk` para definir el nombre de los archivos generados.
4. Reemplazar el contenido de ejemplo en `manuscrito/chapters/`, `manuscrito/assets/`, `plan_tesis/` y `filminas_*`.
5. Agregar bibliografia en los archivos `.bib` correspondientes.

Si esta plantilla se preparo desde una copia de una tesis real, publicar un repositorio nuevo sin conservar el historial anterior. Borrar archivos del arbol actual no elimina automaticamente esos datos del historial de Git.

## Compilar

Para compilar localmente se necesita una instalacion de LaTeX con `latexmk` y `biber`. Si no se quiere instalar nada en la maquina, usar Docker.

Compilar el manuscrito:

```bash
make PROJECT=manuscrito
```

Compilar una entrega especifica:

```bash
make PROJECT=plan_tesis
make PROJECT=filminas_avances
make PROJECT=filminas_defensa
make PROJECT=indice_comentado
```

Compilar todas las entregas:

```bash
make all-projects
```

Los PDFs quedan en `build/<proyecto>/`. La carpeta `build/` no se versiona.

## Compilar con Docker

```bash
docker build -t tesis-latex -f docker/latex/Dockerfile .
docker run --rm -v "$PWD:/workspace" -w /workspace tesis-latex make all-projects
```

Tambien se puede usar el script de contenedor, que permite elegir `docker` o `podman`:

```bash
./scripts/03_build/03_build_container.sh manuscrito
CONTAINER_ENGINE=podman ./scripts/03_build/03_build_container.sh all
BUILD_IMAGE=0 ./scripts/03_build/03_build_container.sh plan_tesis
```

### Compilar nativamente en CachyOS / Arch Linux

Instalar las dependencias una sola vez:

```bash
sudo pacman -Syu --needed \
  make python biber ghostscript \
  texlive-basic texlive-binextra texlive-latexextra \
  texlive-bibtexextra texlive-langspanish \
  texlive-fontsrecommended texlive-fontsextra \
  texlive-mathscience texlive-pictures
```

Luego compilar normalmente:

```bash
make all-projects
```

## Indice comentado

En el manuscrito se puede usar:

```latex
\comentario{Breve descripcion de lo que se desarrolla en esta seccion.}
```

Luego compilar:

```bash
make PROJECT=indice_comentado
```

El script `indice_comentado/extract_index.py` lee los capitulos incluidos en `manuscrito/main.tex` y genera `indice_comentado/contenido.tex` automaticamente.

## GitHub Actions

El workflow `.github/workflows/latex.yaml` valida la compilacion en cada pull request a `main` y en cada push a esa rama. En los pushes a `main`, publica los PDFs como artefactos descargables y copia las salidas finales en `output/`. Si hay cambios, GitHub Actions commitea y pushea esa carpeta automaticamente con `[skip ci]`.

## Limpieza

```bash
make clean PROJECT=manuscrito
make clean-all
```
