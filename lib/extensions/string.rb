class String

  def nan?  # use for checking Strings as valid Floats
    self !~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
  end

  def split_at_indices(indices)
    splits = []
    curr = 0
    indices.each do |i|
      splits << self[curr...i]
      curr = i+1
    end
    splits << self[curr...self.length]
  end

  def camelcase
    split('_').map{ |word| word[0].upcase + word[1..-1] }.join('')
  end

  def underscore
    gsub(/([a-z1-9])([A-Z])/, "\\1_\\2").downcase
  end

end
