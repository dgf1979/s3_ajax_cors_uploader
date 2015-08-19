require 'rails_helper'

RSpec.describe "examples/index", :type => :view do
  before(:each) do
    assign(:examples, [
      Example.create!(
        :name => "Name"
      ),
      Example.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of examples" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
