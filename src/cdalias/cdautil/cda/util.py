from printer import *
from repo import *



class CdaUtil:
    def __init__(self, data_file,app_name,version):
        self.repo = CdaRepo(data_file)
        self.app_name = app_name
        self.version=version



    def navigate(self, alias):
        """
        Used by bash to retrieve the path linked to
        by the specified alias.

        :param alias: alias to use for path lookup
        :return: path associated to alias, or error code
        """
        if not self.repo.does_alias_exist(alias):
            return CODE_ALIAS_NOT_FOUND
        else:
            path = self.repo.get_path_for_alias(alias)
            if self.repo.is_valid_path(path):
                return path
            else:
                return CODE_PATH_NOT_VALID



    def create_alias(self, alias, path):
        """
        Creates link for specified path under given alias.
        If path is not given, current working directory
        is used as a path.
        Also warns if aliases for the path already exist.

        :param alias: alias to be used
        :param path: path to be kinked to the alias
        """
        if not alias:
            print_project_header(self.app_name,"Create alias: %s"%"missing !!",self.version)
        else:
            print_project_header(self.app_name,"Create alias: %s"%alias,self.version)
        # Check if path provided, if not, use current dir
        if path == None:
            path = os.getcwd()
        # Check if alias is provided
        if not alias:
            print_create_no_alias()
            print_project_footer_fail("Error")
            return
        # Check if path already has aliases linking to it
        # and warn if it does
        aliases_for_path = self.repo.get_aliases_for_path(path)
        if len(aliases_for_path) > 0:
            print_create_path_has_aliases_warn(aliases_for_path, path)
        # If alias hasn't already been registered for
        # some other path register it
        if not self.repo.does_alias_exist(alias):
            # If path is not valid abort
            if not self.repo.is_valid_path(path):
                print_create_path_not_valid(alias, path)
                print_project_footer_fail("Error")
                return
            # If path is valid, save
            self.repo.save_alias(alias, path)
            print_create_alias_created(alias, path)
            print_project_footer_success("Done!")
        # If alias has already been registered, abort
        # and display info
        else:
            print_create_alias_exists(alias, self.repo.get_path_for_alias(alias), path)
            print_project_footer_fail("Error")



    def delete_alias(self, alias):
        """
        Deletes alias if it exists.

        :param alias: alias to be deleted
        """
        print_project_header(self.app_name, "Delete alias: %s"%alias, self.version)
        if self.repo.does_alias_exist(alias):
            self.repo.delete_alias(alias)
            print_delete_alias_deleted(alias)
            print_project_footer_success("Done!")
        else:
            print_delete_alias_not_found(alias)
            print_project_footer_normal("Sorry...")



    def list(self):
        """
        Lists all registered aliases.
        """
        print_project_header(self.app_name, "List all aliases", self.version)
        print_list(self.repo.get_all_aliases())
        print_project_footer_normal("List of all aliases",LIST_ICON)
