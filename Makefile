.PHONY: apply bump check commit full log help commit_msg_check bump_part_check
.DEFAULT_GOAL := help

HELP_PATH := .
PIPENV_PATH := .
APP_PATH := ./app
IPYNB_PATH := $(APP_PATH)/ipynb
MD_PATH := $(APP_PATH)/md
HTML_PATH := $(APP_PATH)/html

HELP := $(HELP_PATH)/README.md
IPYNB := $(APP:$(APP_PATH)=$(IPYNB_PATH),.py=.ipynb)
MD := $(APP:$(APP_PATH)=$(MD_PATH),.py=.md)
HTML := $(APP:$(APP_PATH)=$(HTML_PATH),.py=.html)

readme_help	= "readme\t${HELP}"
check_help	= "check\tCheck files and do not apply"
apply_help	= "apply\tCheck files and apply the results"
cmt_usage	= commit msg=\"<message>\"
cmt_error	= "Commit message has to be provided. Usage: $(cmt_usage)"
cmt_help	= "$(cmt_usage)\n\tCheck and commit without staged files"
log_help	= "log\tShow git log oneline"
bump_exp	= major|minor|patch
bump_usage	= bump part=\"<${bump_exp}>\"
bump_error	= "Version part has to be provided. Usage: ${bump_usage}"
bump_help	= "$(bump_usage)\n\tCommit and bump the app version"
push_help	= "push\tCheck and push staged files"
git_all_run = $(MAKE) apply && git add . && $(MAKE) bump && git push
git_all_hlp	= "git_all ${cmt_usage} ${bump_usage}\n\tRun \"${git_all_run}\""

help:
	@echo -e ${readme_help}
	echo -e ${check_help}
	echo -e ${apply_help}
	echo -e ${cmt_help}
	echo -e ${push_help}
	echo -e ${bump_help}
	echo -e ${git_all_hlp}
	echo -e ${log_help}
	echo -e 

# app
convert_init:
	

py_to_nb: $(APP) convert_init
	mkdir -p $(IPYNB_PATH)
	jupytext --to ipynb $(APP) --test-strict
	jupytext --to ipynb $(APP) -o $(IPYNB)

nb_to_py: $(IPYNB)
	jupytext --to py:percent $(IPYNB) --test-strict
	jupytext --to py:percent $(IPYNB) -o $(APP)

nb_to_md: $(MD)
	mkdir -p $(MD_PATH)
	jupyter nbconvert --to markdown $(IPYNB)

# commit
apply:
	cirrus run --dirty

bump: bump_part_check commit
	bumpversion "$(firstword $${part})"

check:
	cirrus run

commit: commit_msg_check check
	git commit -m "$(firstword $${msg})"

git_all: commit_msg_check bump_part_check
	${git_all_run}

log:
	git log --oneline

push: commit_msg_check check
	git push

commit_msg_check:
	@[ "$${msg}" ] || ( echo ${cmt_error}; exit 1 )

.ONESHELL:
bump_part_check:
	@if [ ! $(findstring _${part}_,_$(subst |,_,${bump_exp})_) ]
	then
		echo ${bump_error}
		exit 1
	fi
