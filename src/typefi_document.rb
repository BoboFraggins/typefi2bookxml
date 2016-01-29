class TypefiDocument
  def initialize(file)
    begin
      @doc = Nokogiri::XML(File.open(file)) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
      end
    rescue Nokogiri::XML::SyntaxError
      raise EbookimatorError.new('Cannot parse input file. XML is not well formed.')
    end
  end

  def parse!
  end
end
