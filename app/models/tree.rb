class Tree < ApplicationRecord
  belongs_to :user
  has_many :message, through: :user

  def grow
    self.svg_date = generate_tree_svg
    save
  end

  private

  def generate_tree_svg
    message = user.messages
    svg = <<~SVG
      <svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
        <rect x="190" y="300" width="20" height="100" fill="brown"/>
    SVG

    messages.each_with_index do |message, index|
      x = 100 + rand(200)
      y = 50 + rand(250)
      svg += %Q{<a href="/messages/#{message.id}">}
      svg += %Q{<circle cx="#{x}" cy="#{y}" r="10" fill="green" class="leaf" data-message-id="#{message.id}"/>}
      svg += '</a>'
    end

    svg += '</svg>'
    svg
  end
end
