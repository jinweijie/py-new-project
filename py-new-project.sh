#!/bin/bash

MODULE="$1"

if [ -z "$MODULE" ]; then
  echo "USAGE:"
  echo "    py-new.sh <project-name>"
  exit -1
fi

if [ ! -d "$MODULE-project" ]; then
  echo "Building project [$MODULE-project]..."

  # create project structure
  mkdir "$MODULE-project"
  cd "$MODULE-project"
  mkdir {bin,docs,tests,scripts,"$MODULE"}
  touch README.md setup.py \
      "$MODULE/__init__.py" "$MODULE/$MODULE.PY" \
      "tests/__init__.py" "tests/${MODULE}_test.py" \
  
  # init git
  git init
  ../create-gitignore.sh
  git add .
  git ci -m "Initial project."

  # set version with pyenv
  pyenv local 3.7.2

  #create a virtualenv
  virtualenv env
  source env/bin/activate
  pip install --upgrade pip
  pip install nose tdaemon
  pip freeze > requirements-dev.txt
  touch requirements.txt
  git add requirements*.txt
  deactivate
  echo "done."
  echo ""
  echo 'Run `source env/bin/activate` to start developing.'
  echo ""
else
  echo "Project with that name already exists."
  exit -1
fi
