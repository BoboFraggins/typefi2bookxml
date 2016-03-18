class PostProcessor
  def self.cleanup(dirty_xhtml)
    strip_thin_spaces(dirty_xhtml)
  end

  def self.strip_thin_spaces(dirty_xhtml)
    dirty_xhtml.gsub('&#x2009;&#x2014;', '&#x2014;').gsub('&#x2014;&#x2009;', '&#x2014;')
  end
end
