require 'rails_helper'

RSpec.feature "ユーザーログアウト", type: :feature do
  let(:user) { create(:user) }

  scenario "ユーザーがログアウトする" do
    sign_in user
    visit home_path

    click_button "ログアウト"

    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_link("ログイン")
  end
end
