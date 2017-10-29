# author : Takuro Yamazaki
# description : スクレイピングした授乳室、オムツ台情報をDBに格納

import glob
import pandas as pd
import mysql.connector

from setting import *


# mysql server setting
conn = mysql.connector.connect(
    host='localhost',
    port=3306,
    user=MYSQL_USER,
    password=MYSQL_PW,
    database=MYSQL_DB,
)


def create_db() -> None:
    """./dataに格納された授乳室情報をMySQLのDBに保存
    """

    # ./dataに格納された各区市村の授乳室、オムツ台情報
    wards = glob.glob("../data/*.csv")
    df = pd.read_csv(wards[0], index_col=0, dtype=str)

    # すべてを一つのdataframeに格納
    for w in wards[1:]:
        df = pd.concat([df, pd.read_csv(w, index_col=0, dtype=str)], ignore_index=True)

    # スクレイピングした結果のLongtitudeとLatitudeが逆だったので変換
    df = df.rename(columns={'Longtitude': 'Latitude_tmp', 'Latitude': 'Longtitude_tmp'})
    df = df.rename(columns={'Latitude_tmp': 'Latitude', 'Longtitude_tmp': 'Longtitude'})

    if conn.is_connected():
        cur = conn.cursor()
        for key, row in df.iterrows():
            # 文字列は''で囲む必要がある
            row["Name"] ="'"+row["Name"]+"'"
            row["Prefecture"] ="'"+row["Prefecture"]+"'"
            row["Ward"] ="'"+row["Ward"]+"'"
            row["Address"] ="'"+row["Address"]+"'"

            # sql query
            sql_query = "insert into babymap values(" + str(key) + ',' + ','.join(list(row)) + ");"
            try:
                cur.execute(sql_query)
                conn.commit()
            except:
                conn.rollback()
                raise


if __name__ == "__main__":
    create_db()
