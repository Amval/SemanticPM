require 'test_helper'

class ListingCoursesTest < ActionDispatch::IntegrationTest

  setup { host! 'http://api.lvh.me:3000'}

    test 'returns list of all courses' do
      get '/courses'
      assert_equal 200, response.status
      refute_empty response.body
    end
  end