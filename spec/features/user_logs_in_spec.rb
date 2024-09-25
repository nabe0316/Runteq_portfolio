require 'rails_helper'

RSpec.feature "ユーザー認証", type: :feature do
  let(:user) { create(:user, email: 'name@example.com', password: 'password') }

  scenario "有効な認証情報でログインする" do
    visit new_user_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: 'password'

    click_button "ログイン"

    expect(page).to have_text("ログインしました。")
  end
end
