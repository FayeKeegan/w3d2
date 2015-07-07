DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARHCAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  reply_body VARHCAR(255) NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Faye", "Keegan"),
  ("Elton", "Chan"),
  ("Eric", "S.");

INSERT INTO
  questions (title, body, author_id)
VALUES
  ("Who are you?", "I need to know!", 1),
  ("Did I get a strike today!?", "Please no!", 2);

INSERT INTO
  question_follows (question_id, author_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 3);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, reply_body )
VALUES
  (1, NULL, 3, "I'm Eric!");

INSERT INTO
  replies (question_id, parent_reply_id, author_id, reply_body )
VALUES
  (1, 1, 2, "Hey Eric! I'm Elton!!");

INSERT INTO
  question_likes (author_id, question_id)
VALUES
  (2, 1);
