class Shake
  def self.puts(str='')
    $out << "#{str}\n"
  end

  def self.err(str='')
    $err << "#{str}\n"
  end

  def self.executable
    "shake"
  end
end
