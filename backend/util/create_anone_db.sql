CREATE DATABASE anone;
USE anone;

CREATE TABLE babymap(
    id int unsigned,
    Name varchar(256),
    Prefecture varchar(256),
    Ward varchar(256),
    Address varchar(256),
    Latitude double,
    Longtitude double,
    Junyu_num smallint unsigned,
    Omutsu_num smallint unsigned
);