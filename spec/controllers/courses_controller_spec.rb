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

  describe 'show' do
    before do
      xhr :get, :show, format: :json, id: course_id
    end

    subject(:results) { JSON.parse(response.body) }

    context 'when the course exists' do
      let(:course) do
        Course.create!(name: 'Calculus 1',
                       code: 'MATH 1004')
      end
      let(:course_id) { course.id }

      it { expect(response.status).to eq(200) }
      it { expect(results['id']).to eq(course.id) }
      it { expect(results['name']).to eq(course.name) }
      it { expect(results['code']).to eq(course.code) }
    end

    context "when the course doesn't exist" do
      let(:course_id) { -9999 }
      it { expect(response.status).to eq(404) }
    end
  end

  describe 'create' do
    before do
      xhr :post, :create, format: :json, course: { name: 'Databases',
                                                   code: 'COMP 3005' }
    end
    it { expect(response.status).to eq(201) }
    it { expect(Course.last.name).to eq('Databases') }
    it { expect(Course.last.code).to eq('COMP 3005') }
  end

  describe 'update' do
    let(:course) do
      Course.create!(name: 'Software Requirements',
                     code: 'SYSC 3120')
    end
    before do
      xhr :put, :update, format: :json, id: course.id, course: { name: 'Software Project',
                                                                 code: 'SYSC 3110' }
      course.reload
    end
    it { expect(response.status).to eq(204) }
    it { expect(course.name).to eq('Software Project') }
    it { expect(course.code).to eq('SYSC 3110') }
  end

  describe 'destroy' do
    let(:course_id) do
      Course.create!(name: 'Ancient Roman History',
                     code: 'HIST 2904').id
    end
    before do
      xhr :delete, :destroy, format: :json, id: course_id
    end
    it { expect(response.status).to eq(204) }
    it { expect(Course.find_by_id(course_id)).to be_nil }
  end
end
