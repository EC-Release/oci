__author__ = 'Apolo Yasuda <apolo.yasuda@ge.com>'

'''
   this project was designed to update the cloud-foundry service 1.x
'''

import  os, json, yaml, base64, sys,  threading
from time import sleep

import httplib, urllib, urlparse, json, base64
from shutil import copyfile

#import ec_common
from ec_common import Common

c=Common(__name__)

def main():
    print("hello deployment.")

if __name__=='__main__':
    main()
