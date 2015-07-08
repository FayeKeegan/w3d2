module Saveable

  def mutable_column_names
    names = []
    self.instance_variables.each do |ivar_name|
      next if ivar_name == :@id
      names << ivar_name.to_s[1..-1]
    end

    names
  end

  def mutable_column_values
    self.mutable_column_names.map do |ivar|
      self.send(ivar.to_sym)
    end
  end

  def save
    table_name = self.class::TABLE_NAME

    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *mutable_column_values)
        INSERT INTO
          #{table_name} (#{mutable_column_names.join(",")})
        VALUES
          (#{(["?"]*mutable_column_values.length).join(",")})
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, *mutable_column_values)
        UPDATE
          #{table_name}
        SET
          #{(mutable_column_names).join(" = ?, ")} = ?
        WHERE
          id = #{id}
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

end