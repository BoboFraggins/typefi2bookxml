class SectionTag
  def self.replacement_str(type, inner_text, chapter_index, front_matter)
    type = type.downcase.gsub(' ', '')
    if front_matter
      if type == 'frontmatterintroduction'
        "<supmatl><title>#{inner_text}</title></supmatl>"
      else
        "<supmatl>#{inner_text}</supmatl>"
      end
    else
      case type
      when 'endnotes', 'backmatter'
        "<notes>#{inner_text}</notes>"
      else
        "<chapter id=\"c#{chapter_index}\"></chapter>"
      end
    end
  end
end
