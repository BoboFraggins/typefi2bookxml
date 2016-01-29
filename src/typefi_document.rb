class TypefiDocument
  def initialize(file)
    begin
      @doc = Nokogiri::XML(File.open(file)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
      @doc.remove_namespaces!
    rescue Nokogiri::XML::SyntaxError
      raise Typefi2bookxmlError.new('Cannot parse input file. XML is not well formed.')
    end
  end

  def parse!
    @doc.xpath('//section').each_with_index do |section, section_index|
      front_matter = !!/frontmatter/.match(section.get_attribute('type').downcase)
      section.children.each { |node| parse_node!(node, section_index, front_matter) }
    end
    puts @doc.to_xhtml
  end

  def parse_node!(node, section_index, front_matter)
    node.children.each { |child| parse_node!(child, section_index, front_matter) }
    node.remove if node.name == 's'
    StyleTag.process_node(node, section_index, front_matter) if node.name == 'style'
  end
end
