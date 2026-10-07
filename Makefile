include config/metadata.mk

# =========================
# Project config
# =========================
PROJECT ?= manuscrito
PROJECTS ?= manuscrito plan_tesis filminas_avances filminas_defensa indice_comentado
SRC_DIR := $(PROJECT)
BUILD_DIR := build/$(PROJECT)

TEX_MAIN := $(SRC_DIR)/main.tex

OUTPUT_NAME := $(STUDENT_LAST)_$(STUDENT_NAME)_$(STUDENT_LU)_tesis_$(PROJECT).pdf
OUTPUT_PATH := $(BUILD_DIR)/$(OUTPUT_NAME)

# =========================
# LaTeX config
# =========================
LATEX=pdflatex
LATEXOPT=--shell-escape

LATEXMK = latexmk -$(LATEX) $(LATEXOPT) -pdf \
          -interaction=nonstopmode \
          -halt-on-error

# =========================
# Build
# =========================
all: $(OUTPUT_PATH)

all-projects:
	@for p in $(PROJECTS); do \
		echo "Building $$p..."; \
		$(MAKE) PROJECT="$$p" || exit $$?; \
	done

# LaTeX descubre inclusiones, bibliografía y estilos durante la compilación.
# Forzar el target evita entregar un PDF viejo al editar alguno de esos archivos.
$(OUTPUT_PATH): FORCE
	@if [ "$(PROJECT)" = "indice_comentado" ]; then \
		echo "Running extraction script for $(PROJECT)..."; \
		cd $(SRC_DIR) && python3 extract_index.py; \
	fi
	mkdir -p $(BUILD_DIR)
	cd $(SRC_DIR) && $(LATEXMK) -outdir=../$(BUILD_DIR) main.tex
	mv $(BUILD_DIR)/main.pdf $(OUTPUT_PATH)
	@if [ -f $(BUILD_DIR)/main.pdfpc ]; then \
		mv $(BUILD_DIR)/main.pdfpc $(BUILD_DIR)/$(STUDENT_LAST)_$(STUDENT_NAME)_$(STUDENT_LU)_tesis_$(PROJECT).pdfpc; \
		echo "Generated .pdfpc file for speaker notes."; \
	fi

# =========================
# Clean
# =========================
clean:
	rm -rf build/$(PROJECT)

clean-all:
	rm -rf build/*
	find . -maxdepth 3 \( -name "*.aux" -o -name "*.fdb_latexmk" -o -name "*.fls" -o -name "*.log" -o -name "*.bbl" -o -name "*.blg" -o -name "*.bcf" -o -name "*.run.xml" -o -name "*.nav" -o -name "*.snm" -o -name "*.toc" -o -name "*.out" -o -name "*.synctex.gz" -o -name "main.pdf" -o -name "main.pdfpc" \) -exec rm -f {} +

FORCE:

.PHONY: all all-projects clean clean-all FORCE
