class Tree < ApplicationRecord
  belongs_to :user

  GROWTH_STAGES = {
    seedling: { max_messages: 5, scale: 0.6 },
    sapling: { max_messages: 15, scale: 0.8 },
    mature: { max_messages: 30, scale: 1.0 },
    ancient: { max_messages: Float::INFINITY, scale: 1.2 }
  }

  def grow
    self.svg_data = generate_tree_svg
    save
  end

  def current_stage
    message_count = user.messages.count
    GROWTH_STAGES.each do |stage, data|
      return stage if message_count <= data[:max_messages]
    end
    :ancient
  end

  private

  def generate_tree_svg
    messages = user.messages
    stage = current_stage
    scale = GROWTH_STAGES[stage][:scale]

    svg = %Q{<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">}

    # 幹
    trunk_height = 300 * scale
    svg += %Q{<path d="M200,400 Q180,#{400-trunk_height*0.5} 190,#{400-trunk_height*0.75} T200,#{400-trunk_height}" stroke="brown" stroke-width="#{20*scale}" fill="none" />}

    # 枝
    branches = [
      "M200,#{400-trunk_height} Q170,#{380-trunk_height} 140,#{390-trunk_height}",
      "M200,#{400-trunk_height} Q230,#{380-trunk_height} 260,#{390-trunk_height}",
      "M200,#{400-trunk_height*0.6} Q160,#{380-trunk_height*0.6} 130,#{390-trunk_height*0.6}",
      "M200,#{400-trunk_height*0.6} Q240,#{380-trunk_height*0.6} 270,#{390-trunk_height*0.6}"
    ]
    branches.each do |branch|
      svg += %Q{<path d="#{branch}" stroke="brown" stroke-width="#{10*scale}" fill="none" />}
    end

    # メッセージ数に応じて葉を描画
    messages.each_with_index do |message, index|
      x = 100 + rand(200)
      y = (400 - trunk_height) + rand(trunk_height * 0.8)
      color = ["#7CFC00", "#90EE90", "#98FB98", "#00FA9A"].sample
      svg += generate_leaf(x, y, color, message, scale)
    end

    svg += "</svg>"
    svg.html_safe
  end

  def generate_leaf(x, y, color, message, scale)
    leaf_size = 10 * scale
    %Q{
      <g class="leaf-group" data-controller="leaf-hover">
        <a href="#{Rails.application.routes.url_helpers.message_path(message)}" class="leaf-link" data-message-id="#{message.id}">
          <path d="M#{x},#{y}
                   C#{x-leaf_size*0.5},#{y-leaf_size*0.8} #{x-leaf_size*0.8},#{y-leaf_size*0.3} #{x-leaf_size*0.8},#{y+leaf_size*0.3}
                   C#{x-leaf_size*0.8},#{y+leaf_size*0.8} #{x-leaf_size*0.5},#{y+leaf_size*0.8} #{x},#{y+leaf_size}
                   C#{x+leaf_size*0.5},#{y+leaf_size*0.8} #{x+leaf_size*0.8},#{y+leaf_size*0.8} #{x+leaf_size*0.8},#{y+leaf_size*0.3}
                   C#{x+leaf_size*0.8},#{y-leaf_size*0.3} #{x+leaf_size*0.5},#{y-leaf_size*0.8} #{x},#{y}"
                fill="#{color}" stroke="darkgreen" stroke-width="1" class="leaf">
            <title>#{message.title}</title>
          </path>
        </a>
        <text x="#{x}" y="#{y}" dy="-15" class="leaf-info" style="display: none; font-size: #{10 * scale}px; fill: #333;">
          <tspan x="#{x}" dy="-1.2em">#{message.title}</tspan>
          <tspan x="#{x}" dy="1.2em">#{message.created_at.strftime('%Y-%m-%d %H:%M')}</tspan>
        </text>
      </g>
    }
  end
end
