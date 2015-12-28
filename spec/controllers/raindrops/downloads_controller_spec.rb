require 'spec_helper'

describe Raindrops::DownloadsController, type: :controller, download: true do
  routes { Raindrops::Engine.routes }

  context 'GET downloads' do
    it 'returns HTTP status OK' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST download' do
    context 'with invalid PARAMS' do
      it 'returns HTTP status OK' do
        expect { post :create }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'with valid PARAMS' do
      it 'returns HTTP status OK' do
        post :create, params: { download: { source_url: 'http://dummy-site/resource.txt' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'DELETE download' do
    before { @download = create :download }

    context 'with invalid ID' do
      it 'returns HTTP status NOT FOUND' do
        expect {
          delete :destroy, params: { id: 24 }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with valid id' do
      it 'returns HTTP status OK' do
        delete :destroy, params: { id: @download.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
