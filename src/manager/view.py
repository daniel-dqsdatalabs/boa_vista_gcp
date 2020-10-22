# -*- coding: utf-8 -*-
#==============================================================================
# filename          : views.py
# description       : 
# author            : daniel
# email             : daniel@dqsdatalabs.com
# date              : 17.10.2020
# version           : 0.01
#==============================================================================

import os
import json
import logging
from typing import List
from pathlib import Path
from google.cloud import bigquery
from google.cloud.bigquery.job import QueryJobConfig, QueryJob

VIEWS_DIR = os.getcwd() + "/.raw_data/.views/"

class ViewManager():
    
    def __init__(self, client, dataset_id):
        self.client = client
        self.dataset_id = dataset_id
    
    def get_views_names(self):
        return [
            p.stem
            for p in Path(VIEWS_DIR).glob("*.sql")
        ]

    def get_view_ddl(self, view_name):
        return Path(VIEWS_DIR).joinpath("%s.sql" % view_name).read_text()
    
    def update_or_create_materialized_view(self, view_name, view_ddl):
        try:
            not self.client.get_table(view_name)
            logging.info('[%s] já existe...', view_name)
        except:
            dataset_ref = self.client.dataset(self.dataset_id)
            view_ref = dataset_ref.table(view_name)        
            view = bigquery.Table(view_ref)
            view.view_query = view_ddl
            view.cache_query = True
            self.client.create_table(view, timeout = 30)
            logging.info("view materializada [%s] criada com sucesso", view_ref.table_id)
            
    def update_or_create_materialized_views(self):
        logging.info("iniciando o processamento das views materializadas")
        views_names = self.get_views_names()
        for view_name in views_names:
            self.update_or_create_materialized_view(
                view_name,
                self.get_view_ddl(view_name)
            )