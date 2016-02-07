class TypefiDocument
  def initialize(file)
    begin
      @doc = Nokogiri::XML(File.open(file)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
      @front = Nokogiri::XML::Node.new 'front', @doc
      @front.inner_html = '<titlegrp><title/></titlegrp><authgrp></authgrp>'
      @body = Nokogiri::XML::Node.new 'body', @doc
      @back = Nokogiri::XML::Node.new 'back', @doc
      @doc.remove_namespaces!
    rescue Nokogiri::XML::SyntaxError
      raise Typefi2bookxmlError.new('Cannot parse input file. XML is not well formed.')
    end
  end

  def parse!
    @doc.xpath('//content').each do |content|
      ContentTag.process_node(content)
      content.children.first.add_previous_sibling(@back)
      content.children.first.add_previous_sibling(@body)
      content.children.first.add_previous_sibling(@front)
    end
    chapter = 0
    @doc.xpath('//section').each do |section|
      type = section.get_attribute('type').downcase
      front_matter = !!/frontmatter/.match(type)
      chapter += 1 unless front_matter
      section.children.each { |node| parse_node!(node, chapter, front_matter) }
      SectionTag.process_node(section, chapter, front_matter)
    end
    @doc.xpath('//supmatl').each { |supmatl| supmatl.parent = @front }
    @doc.xpath('//chapter').each { |chapter| chapter.parent = @body }
    @doc.xpath('//notes').each { |notes| notes.parent = @back }
  end

  def contents
    @doc.to_xhtml
  end

  def parse_node!(node, section_index, front_matter)
    node.children.each { |child| parse_node!(child, section_index, front_matter) }
    case node.name.downcase
    when 'c'
      CTag.process_node(node, section_index, front_matter)
    when 'p'
      PTag.process_node(node, section_index, front_matter)
    when 'style'
      StyleTag.process_node(node, section_index, front_matter)
    when 'context'
      ContextTag.process_node(node, section_index, front_matter)
    when 'fieldset'
      FieldSetTag.process_node(node, section_index, front_matter)
    when 's', 't'
      node.remove
    end
  end
end
