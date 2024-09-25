require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let!(:message) { create(:message, user: user) }
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

      it "newテンプレートを再表示する" do
        post :create, params: { message: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #show" do
    it "指定されたメッセージを表示する" do
      get :show, params: { id: message.id }
      expect(assigns(:message)).to eq(message)
    end
  end

  describe "GET #edit" do
    it "編集フォームを表示する" do
      get :edit, params: { id: message.id }
      expect(assigns(:message)).to eq(message)
    end
  end

  describe "PATCH #update" do
    context "有効なパラメータの場合" do
      it "メッセージを更新する" do
        patch :update, params: { id: message.id, message: valid_attributes }
        message.reload
        expect(message.title).to eq("感謝のメッセージ")
      end

      it "更新後にメッセージ詳細ページにリダイレクトする" do
        patch :update, params: { id: message.id, message: valid_attributes }
        expect(response).to redirect_to(message_path(message))
      end
    end

    context "無効なパラメータの場合" do
      it "メッセージを更新しない" do
        original_title = message.title
        patch :update, params: { id: message.id, message: invalid_attributes }
        message.reload
        expect(message.title).to eq(original_title)
      end

      it "editテンプレートを再表示する" do
        patch :update, params: { id: message.id, message: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "メッセージを削除する" do
      message # 事前にメッセージを作成
      expect {
        delete :destroy, params: { id: message.id }
      }.to change(Message, :count).by(-1)
    end

    it "ホームページにリダイレクトする" do
      delete :destroy, params: { id: message.id }
      expect(response).to redirect_to(home_path)
    end
  end
end
