import requests
from bs4 import BeautifulSoup

import re
import os

repo_url = "https://github.com/J535D165/CoronaWatchNL"
repo_branch = "master"
data_dir = "data/rivm_NL_covid19_national_by_date"

base_dir = os.path.dirname(__file__)
output_dir = os.path.abspath(os.path.join(base_dir, "../data/cw"))


def download():
    for fn in download_list():
        f = os.path.join(output_dir, fn)
        if not os.path.exists(f):
            download_file(fn)


def download_list():
    url = f"{repo_url}/tree/{repo_branch}/{data_dir}"
    print(f"Downloading: {url}")
    page = requests.get(url)
    soup = BeautifulSoup(page.content, 'html.parser')
    for element in soup.select("table.files td.content a"):
        csv_url = element['href']
        # parse i
        match = re.search("[^/]+csv$", csv_url)
        if match:
            yield match.group(0)


def download_file(file_name):
    url = f"{repo_url}/raw/{repo_branch}/{data_dir}/{file_name}"
    print(f"Downloading: {url}")
    output_file = os.path.join(output_dir, file_name)
    # obtain file
    page = requests.get(url)
    with open(output_file, "w") as dest:
        dest.write(page.text)


if __name__ == "__main__":

    download()
