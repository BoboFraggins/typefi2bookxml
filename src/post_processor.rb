# encoding: UTF-8
class PostProcessor
  def self.cleanup(dirty_xhtml)
    strip_thin_spaces(fix_entities(dirty_xhtml))
  end

  def self.strip_thin_spaces(dirty_xhtml)
    dirty_xhtml.gsub(' —', '—').gsub('— ', '—')
  end

  def self.fix_entities(dirty_xhtml)
    dirty_xhtml.gsub!('&amp;#160;', 'STUB_OUT_NBSP_CHAR_ENTITY')
    dirty_xhtml.gsub!('&gt;', 'STUB_OUT_GT_CHAR_ENTITY')
    dirty_xhtml.gsub!('&lt;', 'STUB_OUT_LT_CHAR_ENTITY')
    dirty_xhtml.gsub!('&amp;#x02026;', 'STUB_OUT_GRAPHIC_BREAK_ENTITY')
    dirty_xhtml = HTMLEntities.new(:xhtml1).decode(dirty_xhtml).gsub('&', '&amp;')
    dirty_xhtml.gsub!('STUB_OUT_NBSP_CHAR_ENTITY', '&#160;')
    dirty_xhtml.gsub!('STUB_OUT_GT_CHAR_ENTITY', '&gt;')
    dirty_xhtml.gsub!('STUB_OUT_LT_CHAR_ENTITY', '&lt;')
    dirty_xhtml.gsub!('STUB_OUT_GRAPHIC_BREAK_ENTITY', '&#x02026;')
    dirty_xhtml
  end
end