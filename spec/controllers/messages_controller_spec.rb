require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { title: "感謝のメッセージ", content: "ありがとうございます。" } }
  let(:invalid_attributes) { { title: "", content: "" } }

  before { sign_in user }

  describe "GET #index" do
    it "メッセージ一覧を表示する" do
      message = create(:message, user: user)
      get :index
      expect(assigns(:messages)).to include(message)
    end
  end

  describe "POST #create" do
    context "有効なパラメータの場合" do
      it "新しいメッセージを作成する" do
        expect {
          post :create, params: { message: valid_attributes }
        }.to change(Message, :count).by(1)
      end

      it "ホームにリダイレクトする" do
        post :create, params: { message: valid_attributes }
        expect(response).to redirect_to(home_path)
      end
    end

    context "無効なパラメータの場合" do
      it "新しいメッセージを作成しない" do
        expect {
          post :create, params: { message: invalid_attributes }
        }.to_not change(Message, :count)
      end

      it "テンプレートを再表示する" do
        post :create, params: { message: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
