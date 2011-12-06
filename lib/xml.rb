require 'nokogiri'
require 'request'

class XML
  def initialize(uri)
    @uri = uri
  end

  def href_for(rel)
    doc = Nokogiri::XML(self.to_s)

    node = doc.xpath("//link[@rel='#{rel}']").first
    #uuuuuuuuugh, node isn't a hash, or else I'd #fetch
    return nil unless node
    node[:href]
  end

  def has_node?(node)
    Nokogiri::XML(self.to_s).xpath("//#{node}").first
  end

  def to_s
    @request ||= Request.new(@uri).get
  end
end
