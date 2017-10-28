# coding: utf-8
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
    tmp = "/Users/yamazakitakurou/Documents/project/JPHACKS/TK_1716/backend/app/views"
    return static_file(filename, root=tmp+"/img")


@route('/milk', method="GET")
def milk():
    """最近傍の授乳室を返す
    """
    lat = request.query.get("lat")
    lng = request.query.get("lng")
    
    lat = 35.714263 if lat is None else float(lat)
    lng = 139.761892 if lng is None else float(lng)

    near_spot = np.array(map_utils.get_near_spot(lat, lng, "milk"))
    print(near_spot)

    return template('map', lat=lat, lng=lng, near_spot=near_spot, ptype="milk", url=url)


@route('/omutsu/', method="GET")
def omutsu():
    """最近傍のオムツ台を返す
    """
    lat = request.query.get("lat")
    lng = request.query.get("lng")

    lat = 35.714263 if lat is None else float(lat)
    lng = 139.761892 if lng is None else float(lng)

    near_spot = map_utils.get_near_spot(lat, lng, "omutsu")
    print(near_spot)

    return template('map', lat=lat, lng=lng, near_spot=near_spot, ptype="omutsu", url=url)


if __name__ == "__main__":
    run(host="localhost", port=8080, debug=True, reloader=True)