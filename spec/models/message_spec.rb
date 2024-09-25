require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'バリデーション' do
    it '有効な属性の場合は有効である' do
      message = build(:message)
      expect(message).to be_valid
    end

    it 'タイトルがない場合は無効である' do
      message = build(:message, title: nil)
      expect(message).to_not be_valid
    end

    it '内容がない場合は無効である' do
      message = build(:message, content: nil)
      expect(message).to_not be_valid
    end

    it 'タイトルが100文字を超える場合は無効である' do
      message = build(:message, title: 'あ' * 101)
      expect(message).to_not be_valid
    end

    it '内容が1000文字を超える場合は無効である' do
      message = build(:message, content: 'あ' * 1001)
      expect(message).to_not be_valid
    end
  end

  describe '関連付け' do
    it 'ユーザーに属している' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end
end
