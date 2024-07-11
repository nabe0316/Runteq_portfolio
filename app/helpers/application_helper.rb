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

  def flash_class(type)
    case type
    when 'notice' then 'bg-green-100 border-l-4 border-green-500 text-green-700'
    when 'alert'  then 'bg-red-100 border-l-4 border-red-500 text-red-700'
    when 'error'  then 'bg-red-100 border-l-4 border-red-500 text-red-700'
    else 'bg-blue-100 border-l-4 border-blue-500 text-blue-700'
    end
  end

  def flash_icon(type)
    case type
    when 'notice'
      '<svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>'.html_safe
    when 'alert', 'error'
      '<svg class="h-6 w-6 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>'.html_safe
    else
      '<svg class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>'.html_safe
    end
  end
end
