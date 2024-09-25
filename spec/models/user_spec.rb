require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'バリデーション' do
    it '有効な属性の場合は有効である' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '名前がない場合は無効である' do
      user = build(:user, name: nil)
      expect(user).to_not be_valid
    end

    it 'メールアドレスがない場合は無効である' do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it '重複したメールアドレスの場合は無効である' do
      create(:user, email: 'name@example.com')
      user = build(:user, email: 'name@example.com')
      expect(user).to_not be_valid
    end
  end

  describe '関連付け' do
    it '多数のメッセージを持つ' do
      association = described_class.reflect_on_association(:messages)
      expect(association.macro).to eq :has_many
    end

    it '多数の通知を持つ' do
      association = described_class.reflect_on_association(:notifications)
      expect(association.macro).to eq :has_many
    end
  end
end
