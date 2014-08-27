module ConfParser
  def parse f
    result = {}
    f.each do |s|
      next if is_comment s
      k, v = split_line s
      next unless is_valid k, v
      result[k] = parse_value v
    end

    return result
  end

  module_function :parse


  extend self

  private

  def is_comment s
    s[0] == '#'
  end

  def split_line s
    r = s.split /\s*=\s*/, 2 #2 means we only get two results
    return r[0].strip, r[1].strip
  rescue
    return nil, nil
  end

  def is_valid k, v
    k && v && (! v.index /\s/)
  end

  def parse_value v
    parse_boolean(v) || parse_numeric(v) || v
  end

  def parse_boolean v
    s = v.downcase
    return true if %w{yes true on}.include? s
    return false if %w{no false off}.include? s
    return nil
  end

  def parse_numeric v
    return nil unless n = Float(v) rescue nil
    return n if n.to_s == v
    return n.to_i
  end
end