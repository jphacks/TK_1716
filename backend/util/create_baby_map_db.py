# author : Takuro Yamazaki
# description : スクレイピングした情報をDBに追加

import glob
import pandas as pd
import mysql.connector

# mysql server setting
conn = mysql.connector.connect(
    host='localhost',
    port=3306,
    user='root',
    password='hogehogehoge',
    database='anone',
)

def create_db():
    wards = glob.glob("../data/*.csv")
    df = pd.read_csv(wards[0], index_col=0, dtype=str)

    # すべてを一つのdataframeに格納
    for w in wards[1:]:
        df = pd.concat([df, pd.read_csv(w, index_col=0, dtype=str)], ignore_index=True)

    # スクレイピングしたやつのLongtitudeとLatitudeが逆だったので変換
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

            sql_query = "insert into babymap values(" + str(key) + ',' + ','.join(list(row)) + ");"
            try:
                cur.execute(sql_query)
                conn.commit()
            except:
                conn.rollback()
                raise

create_db()