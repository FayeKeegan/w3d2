class Question

  attr_reader :id, :title, :body, :author_id

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    self.new(query)
  end

  def initialize(options)
    @id = options[id]
    @title = options[title]
    @body = options[body]
    @author_id = options[author_id]
  end

end
