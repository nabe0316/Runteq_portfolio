require 'rails_helper'

RSpec.feature "User authentication", type: :feature do
  let(:user) { create(:user) }

  scenario "user logs out" do
    sign_in user
    visit home_path

    click_button "ログアウト"

    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_link("ログイン")
  end
end
