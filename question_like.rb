class QuestionLike
  attr_reader :id, :question_id, :author_id

  TABLE_NAME = "question_likes"
  extend Recordable
  include Recordable

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = ?
    SQL
    self.new(query.first)
  end

  def self.likers_for_question_id(question_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.author_id
      WHERE
        question_likes.question_id = ?
    SQL
    rows.map do |row|
      User.new(row)
    end
  end

  def self.num_likes_for_question_id(question_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) as num_likes
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
    SQL
    query.first["num_likes"]
  end

  def self.liked_questions_for_author_id(author_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        question_likes.author_id = ?
    SQL
    rows.map do |row|
      Question.new(row)
    end
  end

  def self.most_liked_questions(n)
    rows = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN (
          SELECT
            count(question_likes.id) as like_count, question_id
          FROM
            question_likes
          GROUP BY
            question_id
        ) as count ON questions.id = count.question_id
      ORDER BY
        count.like_count DESC
      LIMIT
        ?
    SQL

    rows.map do |row|
      Question.new(row)
    end
  end

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @author_id = options["author_id"]
  end

end
