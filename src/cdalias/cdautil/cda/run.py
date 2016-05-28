import getopt
import sys

import os
from commons import *
from printer import *
from util import CdaUtil

VERSION="0.0.1.SNAPSHOT"
APP_NAME="cdalias"


def main(protect):
    # Get env vars
    store_file = os.getenv('CDA_STORE', None)
    protect_hash = os.getenv('CDA_HASH',None)

    # Check if caller is trusted
    if protect_hash and ("--cdalias="+protect_hash in sys.argv):
        protect.set_trusted_caller(True)
    else:
        return

    if not store_file:
        return CODE_STORE_NOT_FOUND
    else:
        cda_util = CdaUtil(store_file,APP_NAME,VERSION)
    path = None
    alias = None

    try:
        opts, args = getopt.getopt(sys.argv[1:], "n:hp:a:d:l",
                                   ["cdalias=", "help", "path=", "alias=", "delete=", "list"])
    except getopt.GetoptError:
        show_help(protect)
        return
    for opt, arg in opts:
        if opt in ("-n"):
            if protect.allow_exec:
                print (cda_util.navigate(arg))
            return
        elif opt in ("-h", "--help"):
            show_help(protect)
            return
        elif opt in ("-p", "--path"):
            path = arg
        elif opt in ("-a", "--alias"):
            alias = arg
        elif opt in ("-d", "--delete"):
            if protect.allow_exec:
                cda_util.delete_alias(arg)
            return
        elif opt in ("-l", "--list"):
            if protect.allow_exec:
                cda_util.list()
            return
    if (path or alias) and protect.allow_exec:
        cda_util.create_alias(alias, path)
    else:
        show_help(protect)
        return



def show_help(protect):
    if not protect.allow_exec:
        return
    print_help_h1("HELP: cda util")

    print_help_h2("Options")
    print_help_option("-h", "--help", "Displays the help page you are looking at now.")
    print_help_option("-p", "--path", "Assumes that you want to add a cda alias for specified directory")
    print_help_option("-a", "--alias", "Assumes that you want to add a cda alias for current directory")
    print_help_option("-d", "--delete", "Deletes specified cda alias")
    print_help_option("-l", "--list", "Lists all aliases")

    print_help_h2("Usage")
    print_help_usage("cd <alias>", "You will be taken to the directory this alias is linked to")
    print_help_usage("cd -h")
    print_help_usage("cd --help", "Will display help section")

    print_help_usage("cd -a <alias>")
    print_help_usage("cd -alias=<alias>")
    print_help_usage("cd -p <target_path>")
    print_help_usage("cd --path=<target_path>")
    print_help_usage("cd -p <target_path> -a <alias>")
    print_help_usage("cd --path=<target_path> --alias=<alias>", "Will link alias to the directory")
    print_help_usage("cd -d <alias>")
    print_help_usage("cd --delete=<alias>", "Will delete cda alias")
    print_help_usage("cd -l")
    print_help_usage("cd --list", "Will display all aliases")
    print_blank_line()
    print_double_line()



class Protector:
    def __init__(self):
        self.allow_exec = False



    def allow_exec(self):
        return self.allow_exec



    def set_trusted_caller(self, trusted=False):
        self.allow_exec = trusted



if __name__ == "__main__":
    try:
        main(Protector())
    except KeyboardInterrupt:
        pass
