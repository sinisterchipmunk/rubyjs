class Javascript::Unpacker
  def initialize(string)
    @string = string
  end

  def to_s
    r = ""
    tabspace = "\t"
    depth = 0
    @string.gsub(/;/, ";\n").each_byte do |chr|

      # depth
      case chr
        when ?{, ?( then depth += 1 unless (r+chr.chr)[-2..-1] == "({"
        when ?}, ?) then depth -= 1# unless (r+chr.chr)[-2..-1] == "})"
      end

      # content
      indent = depth > 0 ? tabspace*depth : ''
      case chr
        when ?\s then r << chr unless r[-1] == ?\t || r[-1] == ?\n
        when ?{, ?, then r << chr.chr + "\n" + indent
        when ?\n then r << "\n" + indent
        when ?} then r = r.strip << "\n" + indent + "}"
        else r << chr
      end
    end

    r.strip
  end
end
