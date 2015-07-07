class Reply
  attr_reader :id, :question_id, :parent_reply_id, :author_id, :reply_body
  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    self.new(query)
  end

  def initialize(options)
    @id = options[id]
    @question_id = options[question_id]
    @parent_reply_id = options[parent_reply_id]
    @author_id = options[author_id]
    @reply_body = options[reply_body]
  end

end
