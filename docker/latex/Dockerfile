FROM debian:bookworm-slim

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar solo lo esencial para filminas y manuscrito
# texlive-latex-base: Núcleo de LaTeX
# texlive-latex-extra: Paquetes comunes (como tabularx)
# texlive-bibtex-extra: Soporte para bibliografía
# texlive-lang-spanish: Soporte para español (babel, etc.)
# texlive-fonts-recommended/extra: Fuentes necesarias
# texlive-science: Paquetes para matemáticas y ciencia
# texlive-pictures: Soporte para TikZ y gráficos
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-bibtex-extra \
    texlive-lang-spanish \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-science \
    texlive-pictures \
    biber \
    latexmk \
    make \
    python3 \
    ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
