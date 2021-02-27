import requests
from bs4 import BeautifulSoup
import json
import re


def parse_dashboard():
    dic = dict()
    ini = 0
    try:
        url = "https://uci.edu/coronavirus/dashboard/index.php"
        result = requests.get(url)
        response = requests.get(url)
    except requests.exceptions.ConnectionError:
        return None

    if response:
        soup = BeautifulSoup(response.text, "html.parser")
        tableclass = soup.find("table", attrs={"class": "table"})
        if tableclass:
            td = tableclass.find_all("td")
            while True:
                try:
                    dic[td[ini].get_text()] = td[ini + 1].get_text()
                    ini += 2
                except:
                    break
    with open('dash_json.json', 'w') as f:
        json.dump(dic, f)


parse_dashboard()


def parse_oc():
    dic = dict()
    key = []
    value = []
    try:
        url = "https://occovid19.ochealthinfo.com/coronavirus-in-oc"
        result = requests.get(url)
        response = requests.get(url)
    except requests.exceptions.ConnectionError:
        return None

    if response:
        soup = BeautifulSoup(response.text, "html.parser")
        tableclass = soup.find_all(attrs={"class": "count-h2-title"})
        for i in tableclass:
            key.append(i.get_text().replace('\n', '').strip())

        values = soup.find_all(attrs={"class": "casecount-panel-title"})
        for i in values:
            value.append(i.get_text())
    for i in range(len(key)):
        case = key[i].strip()
        if case == "Cumulative Cases to Date(includes deaths)":
            case = "total_pos_cases"
        elif case == "Daily COVID Positive Cases Received":
            case = "daily_pos_cases"
        elif case == "Cumulative Deaths to Date":
            case = "total_deaths_cases"
        elif case == "Deaths Reported Today":
            case = "daily_deaths_cases"
        elif case == "Cumulative Recovered to Date":
            case = "total_recovered_cases"
        else:
            continue
        counts = re.sub(r'[^\w]', '', value[i])

        dic[case] = int(counts)
    with open('oc_json.json', 'w') as f:
        json.dump(dic, f)


parse_oc()
