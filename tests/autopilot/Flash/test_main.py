# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Tests for the Hello World"""

import ubuntuuitoolkit
import time
import Flash


class MainViewTestCase(Flash.ClickAppTestCase):
    """Generic tests for the Hello World"""

    def test_starts_ups_with_sample_content(self):
        app = self.launch_application()

        #find the UbuntuListView and assign it
        list = app.main_view.select_single(objectName="setsList")

        #within the UbuntuListView, find the standard item with the desired text
        item = list.select_single('Standard',text="Sample Cards")

        #make an assertion to ensure that the test passes for fails
        self.assertEqual((item.visible == True), True)

    def test_rename_cards(self):
        app = self.launch_application()

        #find the name of the first set in the list
        list = app.main_view.select_single(objectName="setsList")
        item = app.main_view.select_single(objectName="0o")

        #active the first set in the list
        list.click_element(object_name="0o")

        #activate the rename dialog

        #use the rename dialog

        #ensure that the rename happened

    def test_review_sample_cards(self):
        pass
