class Tree < ApplicationRecord
  belongs_to :user

  def grow
    self.svg_data = generate_tree_svg
    save
  end

  private

  def generate_tree_svg
    messages = user.messages
    svg = %Q{<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">}

    # 幹
    svg += %Q{<path d="M200,400 Q180,300 190,250 T200,100" stroke="brown" stroke-width="20" fill="none" />}

    # 枝
    branches = [
      "M200,100 Q170,80 140,90",
      "M200,100 Q230,80 260,90",
      "M200,180 Q160,160 130,170",
      "M200,180 Q240,160 270,170"
    ]
    branches.each do |branch|
      svg += %Q{<path d="#{branch}" stroke="brown" stroke-width="10" fill="none" />}
    end

    # メッセージ数に応じて葉を描画
    messages.each_with_index do |message, index|
      x = 100 + rand(200)
      y = 50 + rand(250)
      color = ["#7CFC00", "#90EE90", "#98FB98", "#00FA9A"].sample
      svg += %Q{
        <g class="leaf-group" data-controller="leaf-hover">
          <a href="#{Rails.application.routes.url_helpers.message_path(message)}" class="leaf-link" data-message-id="#{message.id}">
            <circle cx="#{x}" cy="#{y}" r="10" fill="#{color}" class="leaf">
              <title>#{message.title}</title>
            </circle>
          </a>
          <text x="#{x}" y="#{y}" dy="-15" class="leaf-info" style="display: none; font-size: 12px; fill: #333;">
            <tspan x="#{x}" dy="-1.2em">#{message.title}</tspan>
            <tspan x="#{x}" dy="1.2em">#{message.created_at.strftime('%Y-%m-%d %H:%M')}</tspan>
          </text>
        </g>
      }
    end

    svg += "</svg>"
    svg.html_safe
  end
end
