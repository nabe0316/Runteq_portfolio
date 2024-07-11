module ApplicationHelper
  def render_tree_with_links(svg_data, messages)
    doc = Nokogiri::HTML::DocumentFragment.parse(svg_data)
    doc.css('a').each do |link|
      message_id = link['data-message-id']
      link['data-action'] = 'click->tree#navigate'
      link['data-tree-target'] = 'leaf'
    end
    doc.to_html
  end
end
