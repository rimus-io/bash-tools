import datetime
import os

from commons import *



class CdaRepo:
    def __init__(self, data_file):
        self.separator = DATA_SEPARATOR
        self.data_map = {}
        self.data_file = data_file
        if not os.path.exists(data_file):
            self.__clear_data_file()
        else:
            self.__map_data()



    def __clear_data_file(self):
        """
        Completely clears the data store file.
        """
        open(self.data_file, 'w').close()



    def __map_data(self):
        """
        Maps currently existing aliases into memory
        from data store.
        """
        with open(self.data_file, "r") as d_file:
            for line in d_file:
                line_arr = line.replace("\n", "").split(self.separator)
                alias = line_arr[1]
                path = line_arr[2]
                date_linked = line_arr[0]
                self.data_map[alias] = {"alias": alias,
                                        "path": path,
                                        "date_linked": date_linked}
        d_file.close()



    def save_alias(self, alias, path):
        """
        Saves link.

        :param alias: alias that will link to the path specified
        :param path: path to be linked to by alias
        """
        now = self.__datetime_str(datetime.datetime.now())
        self.data_map[alias] = {"alias": alias,
                                "path": path,
                                "date_linked": now}
        self.__persist_map()



    def delete_alias(self, alias):
        """
        Deletes the link.

        :param alias: alias of the link to be deleted
        """
        del self.data_map[alias]
        self.__persist_map()



    def __persist_map(self):
        """
        Persist current list of aliases that'sin memory
        to the data store.
        """
        self.__clear_data_file()
        d_file = open(self.data_file, "w")
        for entry in self.data_map.values():
            self.__write_data_line(d_file, entry["alias"], entry["path"], entry["date_linked"])
        d_file.close()



    def __write_data_line(self, d_file, alias, path, date_time):
        """
        Writes one line of data into the data store.

        :param d_file: data store file
        :param alias: alias to be written
        :param path: path to be written
        :param date_time: date alias was created
        """
        d_file.write("%s%s%s%s%s\n" % (date_time, self.separator, alias, self.separator, path))



    @staticmethod
    def __datetime_str(date_time):
        """
        Formatting utility.

        :param date_time: datetime object to be formatted
        :return: formatted string
        """
        return datetime.datetime.strftime(date_time, '%Y-%m-%d %H:%M:%S')



    def get_aliases_for_path(self, path):
        """
        Checks for aliases that are linking to the path given.

        :param path: path to check for
        :return: list of aliases
        """
        aliases = []
        for entry in self.data_map.values():
            if CdaRepo.append_user_dir(entry["path"]) == CdaRepo.append_user_dir(path):
                aliases.append(entry["alias"])
        return aliases



    def get_all_aliases(self):
        """
        Used to get full list of currently linked aliases.

        :return: list of links
        """
        return self.data_map.values()



    def get_path_for_alias(self, alias):
        """
        Checks map for path linked to the alias.

        :param alias: alias to check against
        :return: path or None
        """
        return CdaRepo.append_user_dir(self.data_map[alias]["path"])



    def does_alias_exist(self, alias):
        """
        Utility to check if specified alias exists.

        :param alias: alias to look for
        :return: True/False
        """
        if not alias:
            return False
        if alias in self.data_map:
            return True
        else:
            return False




    @staticmethod
    def is_valid_path(path):
        """
        Utility to check if path is valid.

        :param path: path to validate
        :return: True/False
        """
        return os.path.isdir(CdaRepo.append_user_dir(path))



    @staticmethod
    def append_user_dir(path):
        """
        Checks if path needs user's home path appended

        :param path: path to check
        :return: path with user's home appended
        """
        if path[0] == "~":
            path_str = path.replace("~", CdaRepo.get_user_dir())
        else:
            path_str = path
        return path_str


    @staticmethod
    def get_user_dir():
        """
        Used to retrieve user's directory

        :return: path to user's home
        """
        return os.path.expanduser("~")
