require 'rails_helper'

RSpec.feature "User signs up", type: :feature do
  scenario "with valid credentials" do
    visit new_user_registration_path

    fill_in "ユーザー名", with: "name"
    fill_in "メールアドレス", with: "name@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード確認", with: "password"

    click_button "登録"

    expect(page).to have_text("アカウント登録が完了しました。")
  end
end
