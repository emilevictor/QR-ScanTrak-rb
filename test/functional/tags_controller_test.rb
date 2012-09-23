require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:one)
    sign_in :user, users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end 

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag" do
    @tag = Hash.new
    @tag[:name] = "TestTag"
    @tag[:address] = "Hurrdurr"
    @tag[:points] = 33
    @tag[:uniqueUrl] = "124lj124klj12lkh1g"
    assert_difference('Tag.count') do
      post :create, tag: @tag
    end

    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should show tag" do 

    @tag = Tag.new
    @tag.name = "TestTag"
    @tag.address = "Hurrdurr"
    @tag.points = 33
    @tag.uniqueUrl = "124lj124klj12lkh1g"
    @tag.user = User.first
    if not @tag.valid?
      puts @tag.errors
    end
    @tag.save

    get :show, id: Tag.first.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tag
    assert_response :success
  end

  test "should update tag" do
    put :update, id: @tag, tag: { address: @tag.address, content: @tag.content, latitude: @tag.latitude, longitude: @tag.longitude, points: @tag.points, name: @tag.name, quizAnswer: @tag.quizAnswer, quizQuestion: @tag.quizQuestion, uniqueUrl: @tag.uniqueUrl }
    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_redirected_to tags_path
  end
end
