#-*- coding: utf-8-*-
# author : Takuro Yamazaki

import sys, os
import bottle

dirpath = os.path.dirname(os.path.abspath(__file__))
sys.path.append(dirpath)
os.chdir(dirpath)

import server
application = bottle.default_app()
