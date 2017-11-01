require 'rails_helper'

RSpec.describe MediaController, type: :controller do
  describe '#index' do
    before do
      FactoryBot.create(:medium)
    end
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'responds successfully' do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it 'returns a 200 response' do
        sign_in @user
        get :index
        expect(response).to have_http_status '200'
      end
    end

    context 'as an unauthenticated user' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe '#show' do
    before do
      @medium = FactoryBot.create(:medium)
    end
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'responds successfully' do
        sign_in @user
        get :show, params: { id: @medium.id }
        expect(response).to be_success
      end

      it 'returns a 200 response' do
        sign_in @user
        get :show, params: { id: @medium.id }
        expect(response).to have_http_status '200'
      end
    end

    context 'as an unauthenticated user' do
      it 'returns a 302 response' do
        get :show, params: { id: @medium.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get :show, params: { id: @medium.id }
        expect(response).to redirect_to user_session_path
      end
    end
  end

end
