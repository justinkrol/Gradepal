require 'spec_helper'

describe CoursesController do
  render_views
  describe 'index' do
    before do
      Course.create!(name: 'SYSC 1005')
      Course.create!(name: 'SYSC 3110')
      Course.create!(name: 'COMP 3005')
      Course.create!(name: 'MATH 1005')

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object['name'] }
    end

    context 'when the search finds results' do
      let(:keywords) { 'sysc' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include 'SYSC 1005'" do
        expect(results.map(&extract_name)).to include('SYSC 1005')
      end
      it "should include 'SYSC 3110'" do
        expect(results.map(&extract_name)).to include('SYSC 3110')
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
