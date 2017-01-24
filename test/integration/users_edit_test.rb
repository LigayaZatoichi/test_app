require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:dave)
    @thedude = users(:thedude)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: "",
                                            email: "foo@invalid",
                                            password: "foo",
                                            password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user) # Log in as a valid user.
    get edit_user_path(@user) # Navigate to the user_edit page.
    assert_template 'users/edit' #Double-checking to see if we are actually on the edit page for users.
    name = "Foo Bar" # Local variables to be used later.
    email = "foo@bar.com" # Local variables to be used later.
    patch user_path(@user), params: { user: {name: name,
                                            email: email,
                                            password: "",
                                            password_confirmation: "" } } # Change the users name and email, then hit submit.
    assert_not flash.empty? # Making sure there is a flash.
    assert_redirected_to @user # Redirecting to the user's profile.
    @user.reload # Reloads the users default page and new patch data.
    assert_equal name, @user.name # Double-checking the users name is equal to the patch.
    assert_equal email, @user.email # Double-checking the users email is equal to the patch.
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {name: name,
                                            email: email,
                                            password: "",
                                            password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: {user: { name: @user, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@thedude)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@thedude)
    patch user_path(@user), params: {user: { name: @user, email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end
end
