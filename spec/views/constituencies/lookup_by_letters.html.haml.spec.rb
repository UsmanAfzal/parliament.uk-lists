require 'rails_helper'

RSpec.describe 'constituencies/lookup_by_letters', vcr: true do
  before do
    assign(:constituencies, [])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current and former constituencies/)
    end

    it 'will render the correct sub-header' do
      expect(rendered).to match(/A to Z - showing results for A/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render pugin/elements/_list' do
      expect(response).to render_template('pugin/elements/_list')
    end
  end
end
