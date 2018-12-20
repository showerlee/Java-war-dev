#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
import sys
from pprint import pprint


def get_php_version():

    URL = sys.argv[1]
    res = requests.get(URL)

    return res.headers["X-Powered-By"]


def main():
    get_php_version()
    print(get_php_version())


if __name__ == "__main__":
    main()