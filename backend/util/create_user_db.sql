CREATE DATABASE anone;
USE anone;

CREATE TABLE users(
    id int unsigned unique,
    user_name varchar(256) unique,
    baby_name varchar(256),
);
