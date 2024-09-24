class Tree < ApplicationRecord
  belongs_to :user

  GROWTH_STAGES = {
    seedling: { max_messages: 10, trunk_scale: 0.6, branch_count: 3 },
    sapling: { max_messages: 20, trunk_scale: 0.8, branch_count: 6 },
    mature: { max_messages: 40, trunk_scale: 1.0, branch_count: 10 },
    ancient: { max_messages: Float::INFINITY, trunk_scale: 1.2, branch_count: 15 }
  }

  LEAF_COLORS = {
    green: '#228B22',
    pink: '#FFC0CB',
    orange: '#FFA500'
  }

  LEAF_SHAPES = %w[circle heart triangle]

  attribute :leaf_color, :string, default: 'green'
  attribute :leaf_shape, :string, default: 'circle'

  validates :leaf_color, inclusion: { in: LEAF_COLORS.keys.map(&:to_s) }
  validates :leaf_shape, inclusion: { in: LEAF_SHAPES }

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

  def shrink
    self.svg_data = generate_tree_svg
    save
  end

  private

  def generate_leaf(x, y, message)
    leaf_size = 13 + rand(5)
    rotation = rand(360)
    current_leaf_color = LEAF_COLORS[leaf_color.to_sym] || LEAF_COLORS[:green]

    leaf_path = case leaf_shape
    when 'heart'
      "M #{x},#{y} l #{leaf_size/2},#{leaf_size/2} l #{leaf_size/2},-#{leaf_size/2} z"
    when 'triangle'
      "M #{x},#{y} l #{leaf_size},0 l -#{leaf_size/2},#{leaf_size} z"
    else # circle
      "M #{x},#{y} m -#{leaf_size},0 a #{leaf_size},#{leaf_size} 0 1,0 #{leaf_size*2},0 a #{leaf_size},#{leaf_size} 0 1,0 -#{leaf_size*2},0"
    end

    %Q{
      <g class="leaf-group" data-controller="leaf-hover" transform="rotate(#{rotation}, #{x}, #{y})">
        <a href="#{Rails.application.routes.url_helpers.message_path(message)}" class="leaf-link" data-message-id="#{message.id}">
          <path d="#{leaf_path}"
                fill="#{current_leaf_color}" stroke="#{darken_color(current_leaf_color, 20)}" stroke-width="1" class="leaf">
            <title>#{message.title}</title>
          </path>
        </a>
        <text x="#{x}" y="#{y}" dy="-#{leaf_size + 5}" text-anchor="middle" class="leaf-info" style="display: none; font-size: 8px; fill: #333;">
          <tspan x="#{x}" dy="-1.2em">#{message.title}</tspan>
          <tspan x="#{x}" dy="1.2em">#{message.created_at.strftime('%Y-%m-%d %H:%M')}</tspan>
        </text>
      </g>
    }
  end

  def define_gradients
    current_leaf_color = LEAF_COLORS[leaf_color.to_sym] || LEAF_COLORS[:green]
    %Q{
      <defs>
        <linearGradient id="trunkGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" style="stop-color:#8B4513;stop-opacity:1" />
          <stop offset="50%" style="stop-color:#A0522D;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#8B4513;stop-opacity:1" />
        </linearGradient>
        <linearGradient id="branchGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" style="stop-color:#A0522D;stop-opacity:0.7" />
          <stop offset="50%" style="stop-color:#CD853F;stop-opacity:0.8" />
          <stop offset="100%" style="stop-color:#A0522D;stop-opacity:0.7" />
        </linearGradient>
        <radialGradient id="leafGradient" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
          <stop offset="0%" style="stop-color:#{lighten_color(current_leaf_color, 20)};stop-opacity:1" />
          <stop offset="100%" style="stop-color:#{current_leaf_color};stop-opacity:1" />
        </radialGradient>
      </defs>
    }
  end

  def generate_tree_svg
    messages = user.messages
    stage = current_stage
    stage_data = GROWTH_STAGES[stage]

    tree_height = calculate_tree_height(stage_data[:trunk_scale])
    viewport_height = [400, tree_height + 50].max
    y_offset = viewport_height - 400

    svg = %Q{<svg width="400" height="#{viewport_height}" viewBox="0 0 400 #{viewport_height}" xmlns="http://www.w3.org/2000/svg">}
    svg += define_gradients
    svg += generate_shadow(stage_data[:trunk_scale], y_offset)
    svg += generate_trunk(stage_data[:trunk_scale], viewport_height)
    branches = generate_branches(stage_data[:branch_count], stage_data[:trunk_scale], viewport_height)
    svg += generate_leaves_and_branches(branches, messages)
    svg += "</svg>"
    svg.html_safe
  end

  def generate_shadow(scale, y_offset)
    %Q{<ellipse cx="200" cy="#{390 + y_offset}" rx="#{100*scale}" ry="#{10*scale}" fill="rgba(0,0,0,0.3)" />}
  end

  def generate_trunk(scale, viewport_height)
    trunk_height = 300 * scale
    trunk_width = 30 * scale
    %Q{<path d="M200,#{viewport_height} C180,#{viewport_height-trunk_height*0.5} 220,#{viewport_height-trunk_height*0.7} 200,#{viewport_height-trunk_height}"
               stroke="url(#trunkGradient)" stroke-width="#{trunk_width}" fill="none" stroke-linecap="round" />}
  end

  def generate_branches(count, scale, viewport_height)
    branches = []
    trunk_height = 300 * scale
    count.times do |i|
      side = i.even? ? 1 : -1
      angle = 30 + rand(40)
      length = (60 + rand(60)) * scale
      start_y = viewport_height - trunk_height + (trunk_height * i / count * 0.9)
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
    branches.each do |branch|
      svg += %Q{<path d="#{branch}" stroke="url(#branchGradient)" stroke-width="10" fill="none" stroke-linecap="round" />}
    end

    leaves_positions = []
    max_leaf_size = 15
    min_distance = max_leaf_size * 2

    messages.each_with_index do |message, index|
      branch = branches[index % branches.length]
      leaf_position = find_available_position(branch, leaves_positions, min_distance)
      leaves_positions << leaf_position
      svg += generate_leaf(leaf_position[:x], leaf_position[:y], message)
    end
    svg
  end

  def find_available_position(branch, existing_positions, min_distance)
    max_attempts = 100
    attempts = 0

    loop do
      position = random_point_around_branch(branch)
      if valid_position?(position, existing_positions, min_distance) || attempts >= max_attempts
        return position
      end
      attempts += 1
    end
  end

  def valid_position?(new_position, existing_positions, min_distance)
    existing_positions.none? do |pos|
      distance = Math.sqrt((new_position[:x] - pos[:x])**2 + (new_position[:y] - pos[:y])**2)
      distance < min_distance
    end
  end

  def random_point_around_branch(branch)
    start_x, start_y, control_x, control_y, end_x, end_y = branch.scan(/[-\d.]+/).map(&:to_f)
    t = rand * 0.6 + 0.2
    base_x = (1-t)**2 * start_x + 2*(1-t)*t * control_x + t**2 * end_x
    base_y = (1-t)**2 * start_y + 2*(1-t)*t * control_y + t**2 * end_y

    angle = rand * 2 * Math::PI
    offset_distance = rand * 30
    x = base_x + offset_distance * Math.cos(angle)
    y = base_y + offset_distance * Math.sin(angle)

    { x: x, y: y }
  end

  def calculate_tree_height(scale)
    trunk_height = 300 * scale
    max_branch_length = 120 * scale
    trunk_height + max_branch_length
  end

  def lighten_color(color_hex, amount)
    hex_to_rgb(color_hex).map { |c| [(c + amount).clamp(0, 255)].pack('C').unpack('H2').first }.join
  end

  def darken_color(color_hex, amount)
    hex_to_rgb(color_hex).map { |c| [(c - amount).clamp(0, 255)].pack('C').unpack('H2').first }.join
  end

  def hex_to_rgb(color_hex)
    color_hex.gsub('#','').scan(/../).map { |color| color.hex }
  end
end
