# author : Takuro Yamazaki
# description : ママパパマップから授乳台，オムツ台情報をスクレイピング

import numpy as np
from bs4 import BeautifulSoup
import urllib
import time
import urllib.request
from urllib.parse import urlparse
import pandas as pd


# 今回はとりあえず東京だけに絞る
HOME_URL = "https://mamamap.jp"
TOKYO_URL = "https://mamamap.jp/area/%E6%9D%B1%E4%BA%AC%E9%83%BD"

def get_area():
    """地域選択
    :param URL: URL string
    :return:
    """
    with open("ku.txt", "r") as r_f:
        for line in r_f:
            li = line.rstrip()
            get_spot(HOME_URL+li)
            time.sleep(300)

def get_spot(AREA_URL: str):
    """地域中の授乳室の場所
    :param AREA_URL: URL string
    :return:
    """
    df = pd.DataFrame(columns=["Name", "Prefecture", "Ward", "Address", "Longtitude", "Latitude", "Junyu_num", "Omutsu_num"])

    prefecture, ward = AREA_URL.split('/')[-2:]
    prefecture_conv = urllib.parse.quote_plus(prefecture, encoding='utf-8')
    ward_conv = urllib.parse.quote_plus(ward, encoding='utf-8')
    AREA_URL = HOME_URL + "/area/" + prefecture_conv + "/" + ward_conv
    html = urllib.request.urlopen(AREA_URL)

    try:
        soup = BeautifulSoup(html, "lxml")
    except:
        soup = BeautifulSoup(html, "html5lib")

    sections = soup.find_all("section", attrs={"id": "listSpot"})
    for sec in sections:
        lis = sec.ul.find_all("li")
        for li in lis:
            df = get_info(HOME_URL+li.a.get("href"), prefecture, ward, df)

    df.to_csv(ward+".csv")
    print(ward+" done!")


def get_info(SPOT_URL: str, prefecture: str, ward: str, df):
    """授乳室の詳細情報取得
    :param SPOT_URL: URL string
    :return:
    """
    spot = SPOT_URL.split('/')[-1]
    spot_conv = urllib.parse.quote_plus(spot, encoding='utf-8')
    SPOT_URL = HOME_URL + "/spot/" + spot_conv

    try:
        html = urllib.request.urlopen(SPOT_URL)

        try:
            soup = BeautifulSoup(html, "lxml")
        except:
            soup = BeautifulSoup(html, "html5lib")

        # 台数の取得
        itemvolume = soup.find("ul", attrs={"class": "itemVolume"})
        junyu = itemvolume.find("dl", attrs={"class": "stastus1"}).dd.find("span", attrs={"class": "volume"})
        omutsu = itemvolume.find("dl", attrs={"class": "stastus2"}).dd.find("span", attrs={"class": "volume"})
        if junyu:
            junyu = junyu.string
        else:
            junyu = "0"

        if omutsu:
            omutsu = omutsu.string
        else:
            omutsu = "0"

        # 住所，緯度経度の取得
        itemprop = soup.find("span", attrs={"itemprop": "address"})
        address = itemprop.a.string
        longtitude, latitude = itemprop.a.get("href").split("=")[-1].split(",")
        row = pd.Series([spot, prefecture, ward, address, longtitude, latitude, junyu, omutsu],
                        index=["Name", "Prefecture", "Ward", "Address", "Longtitude", "Latitude", "Junyu_num", "Omutsu_num"])

        df = df.append(row, ignore_index=True)
        print('append row : ')
        print(row)
        temp_time = np.random.choice([1, 1.5, 2])
        time.sleep(temp_time)

    except urllib.error.HTTPError as e:
        print(e)
        pass

    return df

get_area()
