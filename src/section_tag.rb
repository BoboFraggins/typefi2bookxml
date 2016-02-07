class SectionTag
  def self.process_node(node, chapter_index, front_matter)
    type = node.get_attribute('type').downcase.gsub(' ', '')
    inner_text = node.inner_html.strip
    replace = if front_matter
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
                  "<chapter id=\"c#{sprintf("%02d", chapter_index)}\">#{inner_text}</chapter>"
                end
              end
    node.add_next_sibling(replace)
    node.remove
  end
end
