class Tree < ApplicationRecord
  belongs_to :user

  GROWTH_STAGES = {
    seedling: { max_messages: 5, trunk_scale: 0.6, branch_count: 2 },
    sapling: { max_messages: 15, trunk_scale: 0.8, branch_count: 4 },
    mature: { max_messages: 30, trunk_scale: 1.0, branch_count: 6 },
    ancient: { max_messages: Float::INFINITY, trunk_scale: 1.2, branch_count: 8 }
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
    stage_data = GROWTH_STAGES[stage]

    svg = %Q{<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">}
    svg += define_gradients

    # 影
    svg += generate_shadow(stage_data[:trunk_scale])

    # 幹
    trunk = generate_trunk(stage_data[:trunk_scale])
    svg += trunk

    # 枝と葉
    branches = generate_branches(trunk, stage_data[:branch_count], stage_data[:trunk_scale])
    svg += generate_leaves_and_branches(branches, messages)

    svg += "</svg>"
    svg.html_safe
  end

  def generate_shadow(scale)
    %Q{<ellipse cx="200" cy="390" rx="#{100*scale}" ry="#{10*scale}" fill="rgba(0,0,0,0.3)" />}
  end

  def generate_trunk(scale)
    trunk_height = 300 * scale
    trunk_width = 30 * scale
    %Q{<path d="M200,400 C180,#{400-trunk_height*0.5} 220,#{400-trunk_height*0.7} 200,#{400-trunk_height}"
               stroke="url(#trunkGradient)" stroke-width="#{trunk_width}" fill="none" stroke-linecap="round" />}
  end

  def generate_branches(trunk, count, scale)
    branches = []
    trunk_height = 300 * scale
    count.times do |i|
      side = i.even? ? 1 : -1
      angle = 30 + rand(40)
      length = (60 + rand(60)) * scale
      start_y = 400 - trunk_height + (trunk_height * i / count * 0.9)
      end_x = 200 + side * length * Math.cos(angle * Math::PI / 180)
      end_y = start_y - length * Math.sin(angle * Math::PI / 180)
      control_x = 200 + side * length * 0.5 * Math.cos(angle * Math::PI / 180)
      control_y = start_y - length * 0.5 * Math.sin(angle * Math::PI / 180)
      branch = "M200,#{start_y} Q#{control_x},#{control_y} #{end_x},#{end_y}"
      branches << branch
    end
    branches
  end

  def generate_leaves_and_branches(branches, messages)
    svg = ""
    messages.each_with_index do |message, index|
      branch = branches[index % branches.length]
      leaf_position = random_point_on_branch(branch)
      svg += %Q{<path d="#{branch}" stroke="url(#branchGradient)" stroke-width="10" fill="none" stroke-linecap="round" />}
      svg += generate_leaf(leaf_position[:x], leaf_position[:y], message)
    end
    svg
  end

  def random_point_on_branch(branch)
    start_x, start_y, control_x, control_y, end_x, end_y = branch.scan(/[-\d.]+/).map(&:to_f)
    t = rand * 0.6 + 0.4  # 0.4から1.0の間のランダムな値
    x = (1-t)**2 * start_x + 2*(1-t)*t * control_x + t**2 * end_x
    y = (1-t)**2 * start_y + 2*(1-t)*t * control_y + t**2 * end_y
    { x: x, y: y }
  end

  def generate_leaf(x, y, message)
    leaf_size = 15 + rand(10)
    rotation = rand(360)
    %Q{
      <g class="leaf-group" data-controller="leaf-hover" transform="rotate(#{rotation}, #{x}, #{y})">
        <a href="#{Rails.application.routes.url_helpers.message_path(message)}" class="leaf-link" data-message-id="#{message.id}">
          <path d="M#{x},#{y}
                   C#{x-leaf_size*0.5},#{y-leaf_size*0.8} #{x-leaf_size*0.5},#{y+leaf_size*0.4} #{x},#{y+leaf_size}
                   C#{x+leaf_size*0.5},#{y+leaf_size*0.4} #{x+leaf_size*0.5},#{y-leaf_size*0.8} #{x},#{y}"
                fill="url(#leafGradient)" stroke="darkgreen" stroke-width="1" class="leaf">
            <animate attributeName="opacity" values="1;0.8;1" dur="3s" repeatCount="indefinite" />
            <title>#{message.title}</title>
          </path>
        </a>
        <text x="#{x}" y="#{y}" dy="-15" class="leaf-info" style="display: none; font-size: 8px; fill: #333;">
          <tspan x="#{x}" dy="-1.2em">#{message.title}</tspan>
          <tspan x="#{x}" dy="1.2em">#{message.created_at.strftime('%Y-%m-%d %H:%M')}</tspan>
        </text>
      </g>
    }
  end

  def define_gradients
    %Q{
      <defs>
        <linearGradient id="skyGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" style="stop-color:#87CEEB;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#E0F6FF;stop-opacity:1" />
        </linearGradient>
        <linearGradient id="groundGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" style="stop-color:#8B4513;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#A0522D;stop-opacity:1" />
        </linearGradient>
        <linearGradient id="trunkGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" style="stop-color:#8B4513;stop-opacity:1" />
          <stop offset="50%" style="stop-color:#A0522D;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#8B4513;stop-opacity:1" />
        </linearGradient>
        <linearGradient id="branchGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" style="stop-color:#A0522D;stop-opacity:1" />
          <stop offset="50%" style="stop-color:#CD853F;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#A0522D;stop-opacity:1" />
        </linearGradient>
        <linearGradient id="leafGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#32CD32;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#228B22;stop-opacity:1" />
        </linearGradient>
      </defs>
    }
  end
end
