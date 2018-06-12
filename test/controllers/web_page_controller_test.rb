require 'test_helper'

class WebPageControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get web_page_home_url
    assert_response :success
  end

end
