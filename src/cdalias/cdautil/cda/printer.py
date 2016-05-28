import subprocess



# Colours
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
class Colour:
    DEFAULT= '\033[39m'
    BLACK = '\033[30m'
    WHITE = '\033[97m'
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[34m'
    LIGHTBLUE = '\033[94m'
    GREEN = '\033[32m'
    LIGHTGREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'
    FRAMED = '\033[51m'
    GRAY = '\033[37m'
    DARKGRAY = '\033[90m'
    BG_WHITE = '\033[107m'
    BG_BLACK = '\033[40m'
    BG_GRAY = '\033[47m'
    BG_DARKGRAY = '\033[100m'



# Generic
NEW_LINE = "\n"
LEFT_MARGIN=16
HEADLINE_WIDTH=70
LEFT_INDENT=8
LIST_INDENT=2
TABLE_LABEL_PADDING=4

# For symbols:
# http://www.w3schools.com/charsets/ref_utf_symbols.asp

# Arrows and angles
LEFTWARDS_DASHED_ARROW = u'\u21E0'.encode('utf-8')
UPWARDS_DASHED_ARROW = u'\u21E1'.encode('utf-8')
RIGHTWARDS_DASHED_ARROW = u'\u21E2'.encode('utf-8')
DOWNWARDS_DASHED_ARROW = u'\u21E3'.encode('utf-8')
DASHED_ARROW = u'\u27A0'.encode('utf-8')
OPEN_OUTL_ARROW = u'\u27BE'.encode('utf-8')
RIGHT_ARROWHEAD = u'\u27A4'.encode('utf-8')
RIGHT_ROUND_ARROW = u'\u279C'.encode('utf-8')
LEFT_ANGLE = u'\u276E'.encode('utf-8')
RIGHT_ANGLE = u'\u276F'.encode('utf-8')

# Icons
INFO_ICON = u'\u2139'.encode('utf-8')
INFO2_ICON = u'\u2148'.encode('utf-8')
TICK_BIG_ICON = u'\u2714'.encode('utf-8')
CROSS_BIG_ICON = u'\u2718'.encode('utf-8')
WARN_ICON = u'\u26A0'.encode('utf-8')
ATOM_ICON = u'\u269B'.encode('utf-8')
FILLED_SUN_ICON= u'\u2600'.encode('utf-8')
CLOUD_ICON= u'\u2601'.encode('utf-8')
FILLED_FLAG_ICON=u'\u2691'.encode('utf-8')
CIRCLED_STAR_ICON=u'\u272A'.encode('utf-8')
FILLED_STAR_ICON=u'\u2605'.encode('utf-8')
MULTIPLY_BIG_ICON=u'\u2716'.encode('utf-8')
LIST_ICON=u'\u2630'.encode('utf-8')
LIGHTNING_ICON=u'\u26A1'.encode('utf-8')
TRICOLON_ICON=u'\u205D'.encode('utf-8')
HYPHENATION_POINT_ICON=u'\u2027'.encode('utf-8')

# Circles
CIRCLE_FISHEYE = u'\u25C9'.encode('utf-8')
CIRCLE_BULLSEYE = u'\u25CE'.encode('utf-8')
CIRCLE_WITH_VERTICAL_FILL = u'\u25CD'.encode('utf-8')
LOWER_LEFT_CIRCULAR_ARC= u'\u25DF'.encode('utf-8')
LOWER_RIGHT_CIRCULAR_ARC= u'\u25DE'.encode('utf-8')
UPPER_RIGHT_CIRCULAR_ARC= u'\u25DD'.encode('utf-8')
UPPER_LEFT_CIRCULAR_ARC= u'\u25DC'.encode('utf-8')

# Block symbols
FULL_BLOCK = u'\u2588'.encode('utf-8')
LEFT_SEVEN_EIGHTHS_BLOCK = u'\u2589'.encode('utf-8')
LEFT_THREE_QUARTERS_BLOCK = u'\u258A'.encode('utf-8')
LEFT_FIVE_EIGHTHS_BLOCK = u'\u258B'.encode('utf-8')
LEFT_HALF_BLOCK = u'\u258C'.encode('utf-8')
LEFT_THREE_EIGHTHS_BLOCK = u'\u258D'.encode('utf-8')
LEFT_ONE_QUARTER_BLOCK = u'\u258E'.encode('utf-8')
LEFT_ONE_EIGHTH_BLOCK = u'\u258F'.encode('utf-8')
SOLID_BLOCK_FADE = LEFT_SEVEN_EIGHTHS_BLOCK + LEFT_THREE_QUARTERS_BLOCK + LEFT_FIVE_EIGHTHS_BLOCK \
                   + LEFT_THREE_EIGHTHS_BLOCK + LEFT_THREE_EIGHTHS_BLOCK + LEFT_ONE_QUARTER_BLOCK + LEFT_ONE_EIGHTH_BLOCK
RIGHT_ONE_EIGHTH_BLOCK = u'\u2595'.encode('utf-8')
LIGHT_SHADE_BLOCK = u'\u2591'.encode('utf-8')
MEDIUM_SHADE_BLOCK = u'\u2592'.encode('utf-8')
DARK_SHADE_BLOCK = u'\u2593'.encode('utf-8')
LOWER_ONE_EIGHTH_BLOCK = u'\u2581'.encode('utf-8')
UPPER_ONE_EIGHTH_BLOCK = u'\u2594'.encode('utf-8')
QUADRANT_UPPER_LEFT_AND_LOWER_RIGHT = u'\u259A'.encode('utf-8')
QUADRANT_LOWER_RIGHT = u'\u2597'.encode('utf-8')
QUADRANT_LOWER_LEFT = u'\u2596'.encode('utf-8')

# Box
BOX_DRAWINGS_LIGHT_ARC_UP_AND_RIGHT = u'\u2570'.encode('utf-8')
BOX_DRAWINGS_LIGHT_ARC_UP_AND_LEFT = u'\u256F'.encode('utf-8')
BOX_DRAWINGS_LIGHT_ARC_DOWN_AND_RIGHT= u'\u256D'.encode('utf-8')
BOX_DRAWINGS_LIGHT_ARC_DOWN_AND_LEFT= u'\u256E'.encode('utf-8')
BOX_DRAWINGS_LIGHT_HORIZONTAL = u'\u2500'.encode('utf-8')
BOX_DRAWINGS_LIGHT_TRIPLE_DASH_HORIZONTAL= u'\u2504'.encode('utf-8')
BOX_DRAWINGS_LIGHT_DOWN_AND_RIGHT = u'\u250C'.encode('utf-8')
BOX_DRAWINGS_LIGHT_DOWN_AND_LEFT = u'\u2510'.encode('utf-8')



# Basic print
def print_blank_line():
    print("")



def print_dotted_line():
    print_line(".")



def print_dashed_line():
    print_line("- ")



def print_double_line():
    print_line("=")



def print_single_line():
    print_line("-")



def print_line(symbol):
    print(symbol * (get_screen_width() / len(symbol)))



def get_screen_width():
    return int(subprocess.check_output(["tput", "cols"]))



def str_line(symbol):
    return (symbol * (get_screen_width() / len(symbol)))



def str_symbol_times(symbol, times):
    return (symbol * times)



# Templates
class templates:
    # Lengths per element:
    #   FULL_BLOCK          = 1
    #   XXXX_ICON           = 1
    #   Colour.XXXX         = 0
    #   SOLID_BLOCK_FADE    = 7
    __H2_DEFAULT = Colour.WHITE + FULL_BLOCK + Colour.END+ "%s%s" + Colour.END + Colour.WHITE + SOLID_BLOCK_FADE \
                   +Colour.END+ Colour.BOLD + "%s %s" + Colour.END + Colour.END



    @staticmethod
    def padded_icon(icon, padding_l=' ', padding_r=' '):
        return padding_l + icon + padding_r



    @staticmethod
    def __proj_header_default(proj_name, operation=None, version=None):
        r_padding = 8
        screen_w = get_screen_width()
        if operation:
            operation_w = len(operation)
        else:
            operation_w = 0
        if not version:
            version = ""
        version_w = len(version)
        proj_name_w = len(proj_name)
        space_w = proj_name_w
        if operation_w >= space_w:
            space_w = operation_w
        if version_w >= space_w:
            space_w = version_w
        space_w += r_padding
        operation_label = "operation "
        operation_label_w = len(operation_label)
        space_w += operation_label_w
        left_fill_w = LEFT_MARGIN
        right_fill_w = screen_w - (left_fill_w + space_w)
        top_line = Colour.WHITE + str_line("_")+Colour.END + NEW_LINE
        title_line = ("%s %s%s" % (Colour.BG_DARKGRAY + str_symbol_times(" ", left_fill_w) + Colour.END,
                                   Colour.BG_WHITE + Colour.BLACK + " " + proj_name + " " + Colour.END
                                   + Colour.END, str_symbol_times(" ", space_w - proj_name_w - 3) +
                                   Colour.DARKGRAY + str_symbol_times(LIGHT_SHADE_BLOCK,
                                                                      right_fill_w) + Colour.END)) + NEW_LINE
        if operation:
            subtitle_line = NEW_LINE + ("%s %s" % (str_symbol_times(" ", left_fill_w - operation_label_w)
                                                   + Colour.DARKGRAY + Colour.BOLD + operation_label + Colour.END + Colour.END,
                                                   Colour.GRAY + RIGHT_ANGLE + " " + operation + Colour.END)) + NEW_LINE
            bottom_line = Colour.DARKGRAY + str_symbol_times(BOX_DRAWINGS_LIGHT_HORIZONTAL, left_fill_w - 1) \
                          + BOX_DRAWINGS_LIGHT_DOWN_AND_LEFT \
                          + str_symbol_times(" ", space_w) + BOX_DRAWINGS_LIGHT_DOWN_AND_RIGHT + str_symbol_times(
                BOX_DRAWINGS_LIGHT_HORIZONTAL, right_fill_w - 1) + Colour.END + NEW_LINE
            version_str = " %s " % version
            if not version:
                version_str = ""
            version_str_len = len(version_str)
            bottom2_line = Colour.DARKGRAY + SOLID_BLOCK_FADE + str_symbol_times(" ",
                                                                                 left_fill_w - 8) + BOX_DRAWINGS_LIGHT_ARC_UP_AND_RIGHT \
                           + Colour.END + Colour.GRAY + version_str + Colour.END + Colour.DARKGRAY + str_symbol_times(
                BOX_DRAWINGS_LIGHT_HORIZONTAL, space_w - version_str_len) \
                           + BOX_DRAWINGS_LIGHT_ARC_UP_AND_LEFT + Colour.END + NEW_LINE
        else:
            subtitle_line = ""
            bottom_line = Colour.DARKGRAY + str_symbol_times(BOX_DRAWINGS_LIGHT_HORIZONTAL, screen_w) + Colour.END
            bottom2_line = Colour.DARKGRAY + SOLID_BLOCK_FADE + str_symbol_times(" ", left_fill_w - 7) \
                           + LEFT_ONE_EIGHTH_BLOCK + Colour.END + Colour.GRAY + version + Colour.END + NEW_LINE
        return top_line + title_line + subtitle_line + bottom_line + bottom2_line



    @staticmethod
    def __proj_footer_default(text, icon=None, colour=Colour.DEFAULT):
        screen_w = get_screen_width()
        if not icon:
            icon_str=""
            icon_w=0
        else:
            icon_str = templates.padded_icon(icon,"  "," ")
            icon_str = colour + icon_str + Colour.END + Colour.DARKGRAY + templates.padded_icon(RIGHT_ANGLE) + Colour.END
            icon_w=7
        top_line = NEW_LINE   + Colour.WHITE + str_symbol_times(BOX_DRAWINGS_LIGHT_HORIZONTAL,screen_w)+Colour.END + NEW_LINE
        padded_text = " %s " % text
        padded_text_w = len(padded_text)
        long_txt_offset=0
        if (padded_text_w + icon_w) > HEADLINE_WIDTH:
            long_txt_offset = (padded_text_w + icon_w) - HEADLINE_WIDTH

        right_fill_w = screen_w - HEADLINE_WIDTH - long_txt_offset
        status_line = icon_str \
                               + Colour.GRAY +padded_text+ Colour.END \
                        + str_symbol_times(" ",HEADLINE_WIDTH - (padded_text_w+icon_w)) \
                        + Colour.DARKGRAY + str_symbol_times(LIGHT_SHADE_BLOCK,right_fill_w) + Colour.END\
                      + NEW_LINE
        bottom_line =   Colour.WHITE + str_symbol_times(BOX_DRAWINGS_LIGHT_HORIZONTAL,screen_w)+Colour.END + NEW_LINE
        return top_line +status_line+bottom_line


    @staticmethod
    def proj_header(proj_name, operation=None, version=None):
        return templates.__proj_header_default(proj_name, operation, version)\

    @staticmethod
    def proj_footer(text, icon=None, colour=Colour.DEFAULT):
        return templates.__proj_footer_default(text, icon, colour)



    @staticmethod
    def __h2_default(colour, icon, title):
        headline_w = HEADLINE_WIDTH
        graphics_len = 12
        title_str = " " + title
        if not title:
            title_str=""
        title_len = len(title_str)
        title_str = Colour.DARKGRAY + str_symbol_times(LIGHT_SHADE_BLOCK,
                                                       headline_w - graphics_len - title_len) + Colour.END + colour + title_str
        info_str = (templates.__H2_DEFAULT % (colour, icon, colour, title_str)) + NEW_LINE
        top_line = colour + str_symbol_times("_", headline_w) + Colour.END + NEW_LINE
        return top_line + info_str



    @staticmethod
    def h2_normal(title):
        return templates.__h2_default(Colour.END, RIGHT_ANGLE * 3, title)



    @staticmethod
    def h2_success(title):
        return templates.__h2_default(Colour.LIGHTGREEN, templates.padded_icon(TICK_BIG_ICON), title)



    @staticmethod
    def h2_error(title):
        return templates.__h2_default(Colour.RED, templates.padded_icon(CROSS_BIG_ICON), title)



    @staticmethod
    def h2_info(tite):
        return templates.__h2_default(Colour.LIGHTBLUE, templates.padded_icon(INFO_ICON), tite)



    @staticmethod
    def h2_warn(title):
        return templates.__h2_default(Colour.YELLOW, templates.padded_icon(WARN_ICON), title)

    @staticmethod
    def simple_text_line(text,color=Colour.WHITE):
        return color+str_symbol_times(" ",LEFT_INDENT) + text+Colour.END



    @staticmethod
    def error_text_line(text):
        return Colour.RED + str_symbol_times(" ", LEFT_INDENT) + text + Colour.END



    @staticmethod
    def warn_text_line(text):
        return Colour.YELLOW + str_symbol_times(" ", LEFT_INDENT) + text + Colour.END



    @staticmethod
    def simple_list_item(text,icon=None,colour=Colour.WHITE):
        offset=LEFT_INDENT+LIST_INDENT
        icon_str=""
        if icon:
            icon_str = templates.padded_icon(icon,"","")
            text_line=colour+ templates.padded_icon(text," ","") + Colour.END
        else:
            text_line=colour+ text + Colour.END
        top_line=str_symbol_times(" ",offset)+Colour.DARKGRAY +icon_str+ Colour.END + Colour.DARKGRAY \
                 +Colour.END+text_line
        return top_line



    @staticmethod
    def a_to_b_list_item(text_a,text_b, icon=None, colour=Colour.WHITE):
        icon_str = ""
        if icon:
            icon_str = templates.padded_icon(icon, " ", " ")
        offset = LEFT_INDENT + LIST_INDENT
        text_line = str_symbol_times(" ", offset) + colour +text_a+Colour.END + Colour.DARKGRAY + icon_str + Colour.END \
                   + colour + text_b  + Colour.END
        return text_line

    @staticmethod
    def simple_table(labels,field_names,field_colours,items):
        widths_dict={}
        # Find out widest element for each column
        # Get widths from labels first
        for label in labels:
            widths_dict[labels.index(label)] = len(label)
        # Get widths from values
        for item in items:
            for field in field_names:
                last_width=widths_dict[field_names.index(field)]
                item_width=len(item[field])
                if item_width > last_width:
                    widths_dict[field_names.index(field)] = item_width
        # Append labels
        response_str=""
        for label in labels:
            index=labels.index(label)
            if index +1 != len(labels):
                str_formt="%"+str(widths_dict[index]+TABLE_LABEL_PADDING)+"s "
                response_str += Colour.BG_WHITE + Colour.DARKGRAY + Colour.BOLD+ str_formt % label + Colour.END+ Colour.END + Colour.END + " "
            else:
                response_str+=Colour.BG_WHITE + Colour.DARKGRAY + Colour.BOLD+" %s"%label\
                              + str_symbol_times(" ",widths_dict[index]+TABLE_LABEL_PADDING-len(label) )+Colour.END +Colour.END + Colour.END
        response_str += NEW_LINE
        # Populate table
        for item in items:
            for field in field_names:
                index =field_names.index(field)
                if index + 1 != len(field_names):
                    str_formt = "%" + str(widths_dict[index] + TABLE_LABEL_PADDING) + "s"+Colour.DARKGRAY+" "+Colour.END
                    response_str+= field_colours[index] + str_formt % item[field] + Colour.END +Colour.DARKGRAY + "|" +Colour.END
                else:
                    response_str += field_colours[index]+ " %s" % item[field] \
                                    + str_symbol_times(" ", widths_dict[index] + TABLE_LABEL_PADDING
                                    - len(item[field])-1) + Colour.END+Colour.DARKGRAY+"|"+Colour.END
            response_str += NEW_LINE
        # Draw bottom
        for label in labels:
            index = labels.index(label)
            response_str += str_symbol_times(UPPER_ONE_EIGHTH_BLOCK,widths_dict[index]+TABLE_LABEL_PADDING+1) + " "
        response_str += NEW_LINE

        return response_str







# Project specific prints
def print_project_header(proj_name, operation=None, version=None):
    print templates.proj_header(proj_name, operation, version)


def print_project_footer_normal(text,icon=None):
    print templates.proj_footer(text, icon)

def print_project_footer_warn(text):
    print templates.proj_footer(text, FILLED_FLAG_ICON, Colour.YELLOW)

def print_project_footer_fail(text):
    print templates.proj_footer(text, MULTIPLY_BIG_ICON, Colour.RED)

def print_project_footer_success(text):
    print templates.proj_footer(text, FILLED_STAR_ICON, Colour.LIGHTGREEN)



def print_create_alias_exists(alias, existing_path, attempted_path):
    print (templates.h2_error("Duplication"))
    print (templates.error_text_line("Alias '%s' already exists" % alias))
    print_blank_line()
    # Work out alias length
    align_str = "%" + str(len(alias)) + "s"
    print (templates.simple_text_line("Existing mapping:",Colour.DARKGRAY))
    print (templates.a_to_b_list_item(align_str % alias, Colour.GRAY + existing_path + Colour.END, RIGHT_ROUND_ARROW, Colour.DARKGRAY))
    print_blank_line()
    print (templates.simple_text_line("Attempted mapping:",Colour.DARKGRAY))
    print(templates.a_to_b_list_item(align_str % alias, Colour.GRAY + attempted_path + Colour.END, RIGHT_ROUND_ARROW, Colour.DARKGRAY))



def print_create_path_has_aliases_warn(aliases, path):
    print (templates.h2_warn("Duplication"))
    print (templates.warn_text_line("This path already has aliases:"))
    print_blank_line()
    # Work out the longest alias
    max_len=0
    for alias in aliases:
        if len(alias) > max_len:
            max_len=len(alias)
    align_str= "%"+str(max_len)+"s"
    for alias in aliases:
        print (templates.a_to_b_list_item(align_str%alias, Colour.DARKGRAY+path+Colour.END, RIGHT_ROUND_ARROW, Colour.GRAY))
    print_blank_line()



def print_create_path_not_valid(alias, path):
    print (templates.h2_error("Invalid parameter"))
    print (templates.error_text_line("Cannot create alias '%s'..." % alias))
    print_blank_line()
    print (templates.simple_text_line("This path doesn't exist!",Colour.GRAY))
    print_blank_line()
    print (templates.simple_list_item(path,"dir:",Colour.GRAY))

def print_create_no_alias():
    print (templates.h2_error("Missing details"))
    print (templates.error_text_line("Alias not provided!"))
    print_blank_line()
    print (templates.simple_text_line("Usage example:",Colour.DARKGRAY))
    print_blank_line()
    print (templates.simple_list_item("cd -a <alias>","$",Colour.GRAY))
    print (templates.simple_list_item("cd -a <alias> -p <path>","$",Colour.GRAY))



def print_create_alias_created(alias, path):
    print (templates.h2_success("New alias"))
    print (templates.simple_text_line("Alias '%s' created:" % alias))
    print_blank_line()
    align_str = "%" + str(len(alias)+5) + "s"
    print (templates.a_to_b_list_item(align_str%alias,path,RIGHT_ROUND_ARROW,Colour.GREEN))
    print_blank_line()
    print (templates.simple_text_line("Usage example:"))
    print_blank_line()
    print (templates.simple_list_item("cd "+alias,"$",Colour.LIGHTBLUE))



def print_delete_alias_deleted(alias):
    print (templates.h2_success(""))
    print (templates.simple_text_line("Alias '%s' has been deleted" % alias))



def print_delete_alias_not_found(alias):
    print (templates.h2_warn(""))
    print (templates.simple_text_line("Alias '%s' doesn't exist" % alias))



def print_list(items):
    print (templates.h2_info("Aliases"))
    print_blank_line()
    print (templates.simple_table(["Date linked", "Alias", "Path"],
                           ["date_linked","alias","path"],
                           [Colour.GRAY,Colour.YELLOW,Colour.LIGHTGREEN],
                           items))



# Help view
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
