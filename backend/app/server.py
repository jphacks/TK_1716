#-*- coding: utf-8-*-
# author : Takuro Yamazaki
# description : bottle templete engine

import os
import map_utils
import numpy as np

from bottle import route, run, url, request, static_file
from bottle import TEMPLATE_PATH, jinja2_template as template


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
TEMPLATE_PATH.append(BASE_DIR + "/views")


@route("/")
@route('/top')
def top():
    return template('top')


@route('/img/<filename:path>', name='img_file')
def static(filename):
    """views/imgの画像を表示するためのstatic_file設定
    """
    tmp = "/var/www/html/views"
    return static_file(filename, root=tmp+"/img")


@route('/milk', method="GET")
def milk():
    """半径2km以内の授乳室をtempleteに載せる
    """
    lat = request.query.get("lat")
    lng = request.query.get("lng")

    # set default value
    lat = 35.714263 if lat is None else float(lat)
    lng = 139.761892 if lng is None else float(lng)

    # 2km以内の授乳台一覧取得
    near_spot = np.array(map_utils.get_near_spot(lat, lng, "milk"))

    return template('map', lat=lat, lng=lng, near_spot=near_spot, ptype="milk", url=url)


@route('/omutsu', method="GET")
def omutsu():
    """半径2km以内の授乳室をtempleteに載せる
    """
    lat = request.query.get("lat")
    lng = request.query.get("lng")

    # set default value
    lat = 35.714263 if lat is None else float(lat)
    lng = 139.761892 if lng is None else float(lng)

    # 2km以内のオムツ台一覧取得
    near_spot = np.array(map_utils.get_near_spot(lat, lng, "omutsu"))

    return template('map', lat=lat, lng=lng, near_spot=near_spot, ptype="omutsu", url=url)


if __name__ == "__main__":
    run(host="localhost", port=8080, debug=True, reloader=True)
