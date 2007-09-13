DROP TABLE IF EXISTS entries;
DROP TABLE IF EXISTS medias;
DROP TABLE IF EXISTS users;

CREATE TABLE entries (
  id		INT		AUTO_INCREMENT,
  edited	TIMESTAMP,

  uri		VARCHAR(255)	NOT NULL,
  etag		VARCHAR(255),
  body		TEXT		NOT NULL,	# XML

  PRIMARY KEY(id),
  UNIQUE(uri)
);

CREATE TABLE medias (
  id		INT		AUTO_INCREMENT,
  edited	TIMESTAMP,

  entry_uri	VARCHAR(255)	NOT NULL,
  entry_etag	VARCHAR(255),
  entry_body	TEXT		NOT NULL,	# XML

  media_uri	VARCHAR(255)	NOT NULL,
  media_etag	VARCHAR(255),
  media_body	TEXT		NOT NULL,	# Base64
  media_type	VARCHAR(32)	NOT NULL,

  PRIMARY KEY(id),
  UNIQUE(entry_uri)
);


CREATE TABLE users (
  id		INT		AUTO_INCREMENT,
  created_on	TIMESTAMP,

  username	VARCHAR(32)	NOT NULL,
  password	VARCHAR(32)	NOT NULL,

  PRIMARY KEY(id),
  UNIQUE(username)
);

INSERT INTO users (
  username,
  password
)
VALUES (
  'foo',
  'acbd18db4cc2f85cedef654fccc4a4d8'
);

