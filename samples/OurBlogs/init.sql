DROP TABLE IF EXISTS entries;
DROP TABLE IF EXISTS users;

CREATE TABLE entries (
  id		INTEGER	PRIMARY KEY,
  edited	INTEGER,
  uri		TEXT,
  body		TEXT,
  UNIQUE(uri)
);

CREATE TABLE users (
  id		INTEGER	PRIMARY KEY,
  created_on	INTEGER,
  username	TEXT,
  password	TEXT,
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

INSERT INTO users (
  username,
  password
)
VALUES (
  'bar',
  '37b51d194a7513e45b56f6524f2d51f2'
);
