import json

class CatalogInfo(object):
    def __init__(self,
                 dataset_name: str,
                 number_of_tables: int,
                 table_names: [],
                 table_indexes: dict(),
                 dependency: dict(),
                 profile: dict(),
                 columns: dict() = None,
                 #functions: dict() = None,
                 ):
        self.dataset_name = dataset_name
        self.number_of_tables = number_of_tables
        self.table_names = table_names
        self.table_indexes = table_indexes
        self.columns = columns
        self.dependency = dependency
        #self.functions = functions
        self.profile = profile

    def get_dataset_name(self) -> str:
        return self.dataset_name

    def get_number_of_tables(self) -> int:
        return self.number_of_tables

    def get_table_names(self) -> list:
        return [tbl for tbl in self.table_names]

    def get_table_indexes(self):
        return self.table_indexes

    def get_columns(self):
        return self.columns

    def get_dependency(self):
        return self.dependency

    def get_profile(self):
        return self.profile

    def metadata_to_dict(self):
        profile_dict = {'dataset_name': self.get_dataset_name(),
                         'number_of_tables': self.get_number_of_tables(),
                         'table_names': self.get_table_names(),
                         'table_indexes': self.get_table_indexes(),
                         #'schema': self.get_schema(),
                         'dependency': self.get_dependency(),
                         'profile': self.get_profile()
                        }
        return profile_dict

    def table_to_dict(self, table_name: str):
        profile_dict = {'table': table_name, 'rows': self.get_profile()[table_name]['rows'] ,'columns': self.get_columns()[table_name]}
        return profile_dict


def load_catalog(catalog_path: str = None):
    metadata_fname = f"{catalog_path}/metadata.json"
    with open(metadata_fname, 'r') as file:
        raw_data = file.read().replace('\n', '')
        json_data = json.loads(raw_data)
        catalog = CatalogInfo(**json_data)
        # load table metadata
        schema = dict()
        # functions = dict()
        for tbl in catalog.get_table_names():
            table_fname = f"{catalog_path}/{tbl}.json"
            with open(table_fname, 'r') as file:
                raw_data = file.read().replace('\n', '')
                json_data = json.loads(raw_data)
                schema[tbl] = json_data["columns"]
        catalog.schema = schema
        return catalog