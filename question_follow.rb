class QuestionFollow
  attr_reader :id, :question_id, :author_id

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.id = ?
    SQL
    self.new(query.first)
  end

  def self.followers_for_question_id(question_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users ON author_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    rows.map do |row|
      User.new(row)
    end
  end

  def self.followed_questions_for_author_id(author_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        question_follows.author_id = ?
    SQL
    rows.map do |row|
      Question.new(row)
    end
  end

  def self.most_followed_questions(n)
    rows = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.*
      FROM
        questions
      JOIN (
          SELECT
            count(author_id) as follower_count, question_id
          FROM
            question_follows
          GROUP BY
            question_id
        ) as count ON questions.id = count.question_id
      ORDER BY
        count.follower_count DESC
    SQL

    rows.take(n).map do |row|
      Question.new(row)
    end
  end

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @author_id = options["author_id"]
  end

end
