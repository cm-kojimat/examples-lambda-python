from typing import Any

from bs4 import BeautifulSoup

from examples_lambda_python_lib.lib import example


def handler(event: Any, context: Any) -> str:
    example()
    soup = BeautifulSoup("<p>Some<b>bad<i>HTML")
    return soup.prettify()
