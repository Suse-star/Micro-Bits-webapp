DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS history;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS microbit;
DROP TABLE IF EXISTS warning_event;

CREATE TABLE user (
    'id' INTEGER PRIMARY KEY AUTOINCREMENT,
    'username' TEXT UNIQUE NOT NULL,
    'password' TEXT NOT NULL
);

CREATE TABLE room (
    'id' INTEGER PRIMARY KEY AUTOINCREMENT,
    'description' TEXT UNIQUE NOT NULL,
    'width' FLOAT,
    'deepth' FLOAT
);

CREATE TABLE microbit (
    'id' CHAR(5) PRIMARY KEY,
    'name' TEXT,
    'room' INTEGER,
    'temp' INTEGER,
    'light' INTEGER,
    'position_x' FLOAT DEFAULT -1,
    'position_y' FLOAT DEFAULT -1,
    'status' TEXT NOT NULL,
    'min_temp' INTEGER,
    'min_light' INTEGER,
    'max_temp' INTEGER,
    'max_light' INTEGER,
    'mail' VARCHAR(320),
    
    FOREIGN KEY ('room') REFERENCES room ('id')
);

CREATE TABLE history (
    'id' INTEGER PRIMARY KEY AUTOINCREMENT,
    'date' DATE NOT NULL DEFAULT (DATE('now', 'localtime')),
    'microbit' CHAR(5) NOT NULL,
    'min_temp' INTEGER,
    'max_temp' INTEGER,
    'min_light' INTEGER,
    'max_light' INTEGER,

    FOREIGN KEY ('microbit') REFERENCES microbit('id')
);

CREATE TABLE warning_event (
    'id' INTEGER PRIMARY KEY AUTOINCREMENT,
    'date' DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    'microbit' CHAR(5) NOT NULL,
    'msg' VARCHAR(100),

    FOREIGN KEY ('microbit') REFERENCES microbit('id')
);

CREATE TRIGGER delete_old_history AFTER INSERT ON history
BEGIN
    DELETE FROM history WHERE date < DATE('now', '-14 day');
END;
