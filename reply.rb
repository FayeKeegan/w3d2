class Reply
  attr_reader :id, :question_id, :parent_reply_id, :author_id, :reply_body

  TABLE_NAME = "replies"
  extend Recordable
  include Recordable

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    self.new(query.first)
  end

  def self.find_by_author_id(author_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.author_id = ?
    SQL
    rows.map {|row| self.new(row)}
  end

  def self.find_by_parent_reply_id(parent_reply_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply_id = ?
    SQL
    rows.map {|row| self.new(row)}
  end


  def self.find_by_question_id(question_id)
    rows = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL
    rows.map {|row| self.new(row)}
  end

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @author_id = options["author_id"]
    @reply_body = options["reply_body"]
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_reply_id(id)
  end

end
