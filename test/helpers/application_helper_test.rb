require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Ruby On Rails Tutorial App"
    assert_equal full_title("Help"), "Help | Ruby On Rails Tutorial App"
    assert_equal full_title("About"), "About | Ruby On Rails Tutorial App"
    assert_equal full_title("Contact"), "Contact | Ruby On Rails Tutorial App"
  end
end
