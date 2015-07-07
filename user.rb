class User
  attr_reader :id, :fname, :lname

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL
    self.new(query)
  end

  def initialize(options)
    @id = options[id]
    @fname = options[fname]
    @lname = options[lname]
  end

end
