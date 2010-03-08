class String
  def parenthesize(with = "()")
    with[0].chr + self + with[(with.length == 1 ? 0 : 1)].chr
  end

  def depunctuate
    if self[/\?/]
      "is_"+self.gsub(/\?/, '')
    elsif self[/\!/]
      "force_"+self.gsub(/\!/, '')
    else self
    end
  end
end

