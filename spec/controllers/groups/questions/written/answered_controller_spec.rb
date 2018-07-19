require 'rails_helper'

RSpec.describe Groups::Questions::Written::AnsweredController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index, params: { group_id: 'fpWTqVKh'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @answering_body, @answers and @answers_grouped_by_date' do
      expect(assigns(:answering_body).type).to eq('https://id.parliament.uk/schema/AnsweringBody')

      assigns(:answers).each do |answer|
        expect(answer.type).to eq('https://id.parliament.uk/schema/Answer')
      end

      expect(assigns(:answers_grouped_by_date).keys.first).to be_a(Date)

      expect(assigns(:answers_grouped_by_date).values.first.first.type).to eq('https://id.parliament.uk/schema/Answer')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
        {
          route: 'index',
          parameters: { group_id: 'wZVxomZk'},
          data_url: "#{ENV['PARLIAMENT_BASE_URL']}/group_questions_written_answered?group_id=wZVxomZk"
        }
      ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end

    end
  end
end
