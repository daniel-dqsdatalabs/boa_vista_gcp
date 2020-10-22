# -*- coding: utf-8 -*-
#==============================================================================
# filename          : pipeline_manager.py
# description       : 
# author            : daniel
# email             : daniel@dqsdatalabs.com
# date              : 17.10.2020
# version           : 0.01
#==============================================================================

import os
import logging
from .view import ViewManager
from .table import TableManager
from .dataset import DatasetManager
from .analytics import AnalyticsManager

class Pipeline():

    def __init__(self, client, dataset_id, dataset_name):
        self.client = client
        self.dataset_id = dataset_id
        self.dataset_name = dataset_name

    def initialize_pipeline(self):
        dataset_obj = DatasetManager(self.client, self.dataset_id)
        dataset_obj.create_dataset()
        table_obj = TableManager(self.client, self.dataset_name)
        table_obj.update_or_create_tables()
        view_obj = ViewManager(self.client, self.dataset_name)
        view_obj.update_or_create_materialized_views()