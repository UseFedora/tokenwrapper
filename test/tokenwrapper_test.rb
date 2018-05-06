require_relative "test_helper"

class TokenwrapperTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Tokenwrapper::VERSION
  end

  def test_tokenwrap_authentication
    assert_equal("200",Tokenwrapper.getToken.code)
  end
end
