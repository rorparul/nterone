require 'rails_helper'

describe CSV::ExportCourseService do

  context '#to_csv' do
    context 'column categories' do
      let(:platform) { create :platform }
      let(:categories) { create_list(:category, 3) }
      let(:courses) { create_list(:course, 2, categories: categories, platform: platform) }

      subject { CSV::ExportCourseService.new(courses).to_csv }

      it { expect(subject).to include(categories.map(&:title).join(', ')) }
    end
  end

end
