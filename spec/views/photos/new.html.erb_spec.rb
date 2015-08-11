require 'rails_helper'

RSpec.describe "photos/new", :type => :view do
  before(:each) do
    assign(:photo, Photo.new(
      :image => "MyString",
      :timestamps => "MyString"
    ))
  end

  it "renders new photo form" do
    render

    assert_select "form[action=?][method=?]", photos_path, "post" do

      assert_select "input#photo_image[name=?]", "photo[image]"

      assert_select "input#photo_timestamps[name=?]", "photo[timestamps]"
    end
  end
end
