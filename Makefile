SOURCES = ./files/CreateXSH.sh

FOLDER1 = ./debian_openmediavault_installer
PRODUCT1 = ./debian_openmediavault_installer.xsh
SOURCES1 = $(SOURCES)
SOURCES1 += $(shell find $(FOLDER1) -type f)

FOLDER2 = ./debian_openmediavault_sources
PRODUCT2 = ./debian_openmediavault_sources.xsh
SOURCES2 = $(SOURCES)
SOURCES2 += $(shell find $(FOLDER2) -type f)

FOLDER3 = ./debian_opendebianrouter_installer
PRODUCT3 = ./debian_opendebianrouter_installer.xsh
SOURCES3 = $(SOURCES)
SOURCES3 += $(shell find $(FOLDER3) -type f)

.PHONY: all build clean

all: build

build: $(PRODUCT1) $(PRODUCT2) $(PRODUCT3)

clean:
	@$(RM) -fv $(PRODUCT1) $(PRODUCT2) $(PRODUCT3)

$(PRODUCT1): $(SOURCES1)
	@$(BASH) ./files/CreateXSH.sh $(FOLDER1) $(PRODUCT1)

$(PRODUCT2): $(SOURCES2)
	@$(BASH) ./files/CreateXSH.sh $(FOLDER2) $(PRODUCT2)

$(PRODUCT3): $(SOURCES3)
	@$(BASH) ./files/CreateXSH.sh $(FOLDER3) $(PRODUCT3)
