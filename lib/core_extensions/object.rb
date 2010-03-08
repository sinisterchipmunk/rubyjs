class Object
  # Attempts to call #dup, and returns itself if the object cannot be duped (Symbol, Fixnum, etc.)
  def dup?
    dup rescue self
  end
end
