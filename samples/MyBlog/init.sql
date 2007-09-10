DROP TABLE IF EXISTS resources;
DROP TABLE IF EXISTS users;

CREATE TABLE resources (
  id		INT		AUTO_INCREMENT,

  uri		VARCHAR(255)	NOT NULL,

  edited	TIMESTAMP,			# edited and last-modified
  etag		VARCHAR(255),

  type		VARCHAR(32)	NOT NULL,
  body		TEXT		NOT NULL,	# XML or Base64

  PRIMARY KEY(id),
  UNIQUE(uri)
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

