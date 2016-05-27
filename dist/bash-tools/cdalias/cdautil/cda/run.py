import getopt
import os
import sys

from commons import *
from printer import *
from util import CdaUtil



def main():
    store_file = os.getenv('CDA_STORE', None)
    if not store_file:
        return CODE_STORE_NOT_FOUND
    else:
        cda_util = CdaUtil(store_file)
    path = None
    alias = None
    try:
        opts, args = getopt.getopt(sys.argv[1:], "n:hp:a:d:l", ["help", "path=", "alias=", "delete=", "list"])
    except getopt.GetoptError:
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-n"):
            print (cda_util.navigate(arg))
            exit()
        elif opt in ("-h", "--help"):
            show_help()
            exit()
        elif opt in ("-p", "--path"):
            path = arg
        elif opt in ("-a", "--alias"):
            alias = arg
        elif opt in ("-d", "--delete"):
            cda_util.delete_alias(arg)
            exit()
        elif opt in ("-l", "--list"):
            cda_util.list()
            exit()
    if path or alias:
        cda_util.create_alias(alias, path)
    else:
        exit(2)



def exit(code=0):
    sys.exit(code)



def show_help():
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



if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
