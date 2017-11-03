CREATE DATABASE anone;
USE anone;

CREATE TABLE baby_history(
    history_id int unsigned unique,
    user_name varchar(256),
    unchi_date DATETIME
);
