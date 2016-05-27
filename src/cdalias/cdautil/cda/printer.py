import subprocess



# For symbols:
# http://boschista.deviantart.com/journal/Cool-ASCII-Symbols-214218618

def print_create_alias_exists(alias, existing_path, attempted_path):
    print ("")
    print ("    Alias '%s' already exists:" % alias)
    print ("")
    print ("\t Existing mapping: %16s -> %s" % (alias, existing_path))
    print ("\tAttempted mapping: %16s -> %s" % (alias, attempted_path))
    print_dotted_line()



def print_create_path_has_aliases_warn(aliases, path):
    print ("")
    print ("    WARNING: This path already has aliases:")
    print ("")
    for alias in aliases:
        print ("\t%10s  -->  %s" % (alias, path))



def print_create_path_not_valid(alias, path):
    print ("")
    print ("    Cannot create alias '%s', path doesn't exist:" % alias)
    print ("")
    print ("\t %s" % path)
    print_dotted_line()



def print_create_alias_created(alias, path):
    print ("")
    print ("    Alias '%s' created:" % alias)
    print ("")
    print ("\t%10s  -->  %s" % (alias, path))
    print_dotted_line()



def print_delete_alias_deleted(alias):
    print_single_line()
    print ("")
    print ("    Alias '%s' has been deleted!" % alias)
    print_dotted_line()



def print_delete_alias_not_found(alias):
    print_single_line()
    print ("")
    print ("    Alias '%s' doesn't exist" % alias)
    print_dotted_line()



def print_list(items):
    print_double_line()
    print ("%20s %12s        %s" % ("Date linked:", "Alias:", "Path:"))
    print_single_line()
    for entry in items:
        print ("%20s %12s        %s" % (entry["date_linked"], entry["alias"], entry["path"]))
    print_dotted_line()



def print_blank_line():
    print("")



def print_dotted_line():
    print_line(".")



def print_double_line():
    print_line("=")



def print_single_line():
    print_line("-")



def print_line(symbol):
    width = int(subprocess.check_output(["tput", "cols"]))
    print (symbol * width)



def print_help_h1(text):
    print_double_line()
    print_blank_line()
    print ("    %s" % text)
    print_blank_line()
    print_single_line()



def print_help_h2(text):
    print ("")
    print ("      %s" % text.upper())
    print ("")



def print_help_option(short_opt, opt, description):
    if short_opt and opt:
        print ("%10s    %s" % (short_opt, opt))
    if short_opt and not opt:
        print ("%10s" % short_opt)
    if opt and not short_opt:
        print ("%10s" % opt)
    if description:
        print ("\t\t%s" % description)
    print_blank_line()



def print_help_usage(example, description=""):
    print("\t%s" % example)
    if description:
        print("\t\t%s" % description)
        print_blank_line()
