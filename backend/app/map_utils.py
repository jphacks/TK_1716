# coding: utf-8
# author : Takuro Yamazaki
# description :

import sys
import mysql.connector
import numpy as np
import pandas as pd

from setting import *
from math import radians, cos, sin, asin, sqrt
from googlemaps import distance_matrix, client

# sql seting
conn = mysql.connector.connect(
    host='localhost',
    port=3306,
    user='root',
    password=MYSQL_PW,
    database='anone',
)

# google map distance matrix api setting
gmap_client = client.Client(key=GOOGLE_MAPS_DISTANCE_MATRIX_API_Key)

# sqlとのconnectionがきれないようにする
conn.ping(reconnect=True)



def haversine(lng1, lat1, lng2, lat2):
    """緯度経度から直線距離を求める
    :param lng1: float, 経度1
    :param lat1: float, 緯度1
    :param lng2: float, 経度2
    :param lat2: float, 緯度2
    :return: float, 直線距離(km)
    """
    lat1 = float(lat1)
    lat2 = float(lat2)
    lng1 = float(lng1)
    lng2 = float(lng2)

    # convert decimal degrees to radians
    lng1, lat1, lng2, lat2 = map(radians, [lng1, lat1, lng2, lat2])

    # haversine formula
    dlon = lng2 - lng1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))

    # Radius of earth in kilometers is 6371
    km = 6371 * c
    return km


def nearest(api_result):
    """最近の授乳台の場所を返す
    :param api_result: dict, google distance matrix apiの結果
    :return: int, 最近の授乳台が何番目か
    """
    elements = api_result["rows"][0]["elements"]
    min_distance = sys.maxint
    min_index = -1
    for i, e in enumerate(elements):
        if e["status"] == "OK":
            if e["distance"]["value"] < min_distance:
                min_index = i

    return min_index


def get_nearest_spot(lat, lng, ptype):
    """
    :param lat: float, 出発地の緯度
    :param lng: float, 出発地の経度
    :param ptype:　str, オムツ台か授乳台か
    :return: pd.Series, 目的地の緯度経度
    """
    lat = float(lat)
    lng = float(lng)
    cur = conn.cursor()

    # 授乳台もしくはオムツ台が1つ以上ある箇所を取得
    if ptype == 'milk':
        cur.execute('SELECT * FROM babymap where Junyu_num > 0')
    else: # == 'omutsu'
        cur.execute('SELECT * FROM babymap where Omutsu_num > 0')

    # 結果をpd.DataFrameに納める
    query_result = pd.DataFrame(cur.fetchall(),
                               columns=["id", "Name", "Prefecture", "Ward", "Address", "Latitude", "Longtitude", "Junyu_num", "Omutsu_num"])

    # haversine distanceを求める
    query_result["haversine"] = query_result.apply(lambda x: haversine(lng, lat, x[["Longtitude"]], x[["Latitude"]]), axis=1)

    # haversine distanceが2km以下のものだけ取得
    query_result = query_result[query_result['haversine'] < 2]

    # APIで徒歩距離を計算
    nearest_path_result = distance_matrix.distance_matrix(gmap_client, (lat, lng),
                                          np.array(query_result[['Latitude', 'Longtitude']].astype('float')),transit_mode="walking")


    return query_result.iloc[nearest(nearest_path_result)][["Latitude", "Longtitude"]].astype('float')


def get_near_spot(lat, lng, ptype):
    """
        :param lat: float, 出発地の緯度
        :param lng: float, 出発地の経度
        :param ptype:　str, オムツ台か授乳台か
        :return: pd.Series, 目的地の緯度経度
        """
    lat = float(lat)
    lng = float(lng)
    cur = conn.cursor()

    # 授乳台もしくはオムツ台が1つ以上ある箇所を取得
    if ptype == 'milk':
        cur.execute('SELECT * FROM babymap where Junyu_num > 0')
    else:  # == 'omutsu'
        cur.execute('SELECT * FROM babymap where Omutsu_num > 0')

    # 結果をpd.DataFrameに納める
    query_result = pd.DataFrame(cur.fetchall(),
                                columns=["id", "Name", "Prefecture", "Ward", "Address", "Latitude", "Longtitude",
                                         "Junyu_num", "Omutsu_num"])

    # haversine distanceを求める
    query_result["haversine"] = query_result.apply(lambda x: haversine(lng, lat, x[["Longtitude"]], x[["Latitude"]]),
                                                   axis=1)

    # haversine distanceが2km以下のものだけ取得
    query_result = query_result[query_result['haversine'] < 2]

    return query_result[["Name", "Longtitude", "Latitude"]]
