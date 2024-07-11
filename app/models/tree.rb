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

    # 幹を描画
    svg += %Q{<path d="M200,400 Q180,300 190,250 T200,100" stroke="brown" stroke-width="20" fill="none" />}

    # 枝を描画
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
      svg += %Q{<a href="#{Rails.application.routes.url_helpers.message_path(message)}" class="leaf-link" data-message-id="#{message.id}">}
      svg += %Q{<circle cx="#{x}" cy="#{y}" r="10" fill="#{color}">}
      svg += %Q{<animate attributeName="r" values="10;12;10" dur="2s" repeatCount="indefinite" />}
      svg += %Q{</circle>}
      svg += %Q{</a>}
    end

    svg += "</svg>"
    svg
  end
end
