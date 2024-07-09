class Tree < ApplicationRecord
  belongs_to :user

  def grow
    self.svg_data = generate_tree_svg
    save
  end

  private

  def generate_tree_svg
    messages = user.messages
    height = 400
    width = 400

    svg = %Q{
      <svg width="#{width}" height="#{height}" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <radialGradient id="leaf-gradient" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
            <stop offset="0%" style="stop-color:rgb(34,139,34);stop-opacity:1" />
            <stop offset="100%" style="stop-color:rgb(0,100,0);stop-opacity:1" />
          </radialGradient>
        </defs>
    }

    # 地面
    svg += %Q{<path d="M0,#{height} Q#{width/2},#{height-20} #{width},#{height}" fill="green" />}

    # 幹
    trunk_path = "M#{width/2},#{height} Q#{width/2-20},#{height-50} #{width/2-10},#{height-100} T#{width/2},#{height-200}"
    svg += %Q{<path d="#{trunk_path}" stroke="brown" stroke-width="30" fill="none">
      <animate attributeName="d" dur="5s" repeatCount="indefinite"
        values="#{trunk_path};
                M#{width/2},#{height} Q#{width/2+20},#{height-50} #{width/2+10},#{height-100} T#{width/2},#{height-200};
                #{trunk_path}"
      />
    </path>}

    # 枝
    branches = [
      "M#{width/2},#{height-180} Q#{width/2-40},#{height-200} #{width/2-80},#{height-180}",
      "M#{width/2},#{height-180} Q#{width/2+40},#{height-200} #{width/2+80},#{height-180}",
      "M#{width/2},#{height-140} Q#{width/2-30},#{height-160} #{width/2-60},#{height-140}",
      "M#{width/2},#{height-140} Q#{width/2+30},#{height-160} #{width/2+60},#{height-140}"
    ]
    branches.each do |branch|
      svg += %Q{<path d="#{branch}" stroke="brown" stroke-width="10" fill="none" />}
    end

    # 葉（メッセージ）
    messages.each_with_index do |message, index|
      x = width/4 + rand(width/2)
      y = height/4 + rand(height/2)
      svg += %Q{
        <a href="/messages/#{message.id}" class="message-leaf">
          <circle cx="#{x}" cy="#{y}" r="15" fill="url(#leaf-gradient)">
            <animate attributeName="r" values="15;17;15" dur="2s" repeatCount="indefinite" />
          </circle>
          <text x="#{x}" y="#{y}" font-family="Arial" font-size="10" fill="white" text-anchor="middle" dy=".3em">#{index + 1}</text>
        </a>
      }
    end

    svg += "</svg>"

    # JavaScriptを追加してインタラクティブ性を高める
    svg += %Q{
      <script type="text/javascript">
        document.querySelectorAll('.message-leaf').forEach(leaf => {
          leaf.addEventListener('mouseover', () => {
            leaf.querySelector('circle').setAttribute('r', '20');
          });
          leaf.addEventListener('mouseout', () => {
            leaf.querySelector('circle').setAttribute('r', '15');
          });
        });
      </script>
    }

    svg
  end
end
