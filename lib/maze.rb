class Maze
  def initialize(uri)
    @xml_cache = {}
    @uri = uri
    @uri = xml.href_for('start')
  end

  def visit(uri)
    @uri = uri
  end

  def can_go?(direction)
    xml.href_for(direction)
  end

  def finished?
    xml.has_node?('completed')
  end

  private

  def xml
    @xml_cache[@uri] ||= XML.new(@uri)
  end
end
