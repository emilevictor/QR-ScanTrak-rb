require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:one)
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
    assert_difference('Tag.count') do
      post :create, tag: { QRCode: @tag.QRCode, address: @tag.address, content: @tag.content, createdBy: @tag.createdBy, latitude: @tag.latitude, longitude: @tag.longitude, name: @tag.name, quizAnswer: @tag.quizAnswer, quizQuestion: @tag.quizQuestion, unique: @tag.unique, uniqueUrl: @tag.uniqueUrl }
    end

    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should show tag" do
    get :show, id: @tag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tag
    assert_response :success
  end

  test "should update tag" do
    put :update, id: @tag, tag: { QRCode: @tag.QRCode, address: @tag.address, content: @tag.content, createdBy: @tag.createdBy, latitude: @tag.latitude, longitude: @tag.longitude, name: @tag.name, quizAnswer: @tag.quizAnswer, quizQuestion: @tag.quizQuestion, unique: @tag.unique, uniqueUrl: @tag.uniqueUrl }
    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_redirected_to tags_path
  end
end
