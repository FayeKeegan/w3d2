class QuestionLike
  attr_reader :id, :question_id, :author_id

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

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @author_id = options["author_id"]
  end

end
