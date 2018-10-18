#!/bin/bash
install_venv(){
  python -m venv env
  . env/bin/activate || . env/Scripts/activate
  python -m pip install --upgrade pip
  pip install -r requirements.txt 
}