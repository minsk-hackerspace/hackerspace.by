require 'rails_helper'

RSpec.describe UploaderController, type: :controller do
  describe 'POST #image' do
    let(:user) { create :user }
    let(:uploaded_file) do
      fixture_file_upload(Rails.root.join('spec', 'support', 'image.jpg'), 'image/jpg')
    end

    context 'as an authenticated user' do
      before do
        sign_in user
      end

      it 'uploads the file and returns the location' do
        post :image, params: { file: uploaded_file }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('text/html; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('location')
        expect(json_response['location']).to include('/rails/active_storage/blobs/')

        blob = ActiveStorage::Blob.last
        expect(blob.filename.to_s).to eq('image.jpg')
      end
    end

    context 'as a guest' do
      it 'is expected to be redirected to sign in page' do
        post :image, params: { file: uploaded_file }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
