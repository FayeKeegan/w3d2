class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL
    self.new(query.first)
  end

  def self.find_by_name(fname, lname)
    query = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = :fname AND users.lname = :lname
    SQL
    self.new(query.first)
  end

  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_author_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_author_id(id)
  end

  def average_karma
    average_karma = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) /
        CAST(COUNT(DISTINCT questions.id) AS FLOAT)
          AS avg_karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
      GROUP BY
        questions.author_id
    SQL
    average_karma.first ? average_karma.first["avg_karma"] : 0.0
  end

  def save
    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (?, ?)
      SQL
      @id = (QuestionsDatabase.instance.execute("SELECT last_insert_rowid() AS id")).first["id"]
      # @id = User.find_by_name(fname, lname).id
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end

    true
  end

end
