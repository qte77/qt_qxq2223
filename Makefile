.PHONY: help
.DEFAULT_GOAL := help

HELP_PATH := .
PIPENV_PATH := .
APP_PATH := ./app
IPYNB_PATH := $(APP_PATH)/ipynb
MD_PATH := $(APP_PATH)/md
HTML_PATH := $(APP_PATH)/html
RUNS_PATH := $(APP_PATH)/runs

HELP := $(HELP_PATH)/README.md
IPYNB := $(APP:$(APP_PATH)=$(IPYNB_PATH),.py=.ipynb)
MD := $(APP:$(APP_PATH)=$(MD_PATH),.py=.md)
HTML := $(APP:$(APP_PATH)=$(HTML_PATH),.py=.html)

RUNS_CUR != date + "%y-%m-%d_%H-%M-%S"
PY_BIN != /usr/bin/env python

convert_init:
		

py_to_nb: convert_init
	mkdir -p $(IPYNB_PATH)
	jupytext --to ipynb $(APP) --test-strict
	jupytext --to ipynb $(APP) -o $(IPYNB)

nb_to_py: $(IPYNB)
	jupytext --to py:percent $(IPYNB) --test-strict
	jupytext --to py:percent $(IPYNB) -o $(APP)

nb_to_md: $(MD)
	mkdir -p $(MD_PATH)
	jupyter nbconvert --to markdown $(IPYNB)
