# Test for the rails controller

require 'spec_helper'

describe CoursesController do
  render_views
  describe 'index' do
    before do
      Course.create!(name: 'Intro to Programming')
      Course.create!(name: 'Software Project')
      Course.create!(name: 'Databases')
      Course.create!(name: 'Differential Equations')

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object['name'] }
    end

    context 'when the search finds results' do
      let(:keywords) { 'pro' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include 'Intro to Programming'" do
        expect(results.map(&extract_name)).to include('Intro to Programming')
      end
      it "should include 'Software Project'" do
        expect(results.map(&extract_name)).to include('Software Project')
      end
    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end
  end
end
