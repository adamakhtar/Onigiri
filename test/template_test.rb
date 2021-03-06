require 'helper'

class TestTemplate < MiniTest::Unit::TestCase
  def setup 
    @template = Onigiri::Template.new([:scalar_measurement, :measurement])
    @tok_a = Onigiri::Token.new("10")
    @tag_a = Onigiri::ScalarMeasurement.new(10)
    @tok_a.add_tag(@tag_a)
    @tok_b = Onigiri::Token.new("grams")
    @tag_b = Onigiri::Measurement.new("grams")
    @tok_b.add_tag(@tag_b)
  end

  def test_has_a_pattern
    assert_equal [:scalar_measurement, :measurement], @template.pattern
  end

  def test_template_matches_tokens_and_returns_matchset
    matchset = @template.match [@tok_a, @tok_b]
    assert_equal [@tag_a, @tag_b], matchset.matches
  end

  def test_template_does_not_match_tokens_in_wrong_order
    refute @template.match [@tok_b, @tok_a]
  end

  def test_template_match_fails_if_unmatched_pattern_parts_exist
    refute @template.match [@tok_a]
  end

  def test_template_match_allows_optional_pattern_elements_to_not_match
    not_optional = Onigiri::Template.new([:scalar_measurement, :ingredient, :measurement])
    optional     = Onigiri::Template.new([:scalar_measurement, :ingredient?, :measurement])
    assert optional.match([@tok_a, @tok_b])
    refute not_optional.match([@tok_a, @tok_b])
  end

  # i.e. for pattern => :a,:b: given tokens => a,x,y,b - the method will match.
  def test_nonstrict_match_allows_unrelated_tokens_to_be_present
    template = Onigiri::Template.new([:scalar_measurement, :measurement])
    blah_token  = Onigiri::Token.new("99")
    blah_tag = Onigiri::ScalarMeasurement.new(99)
    blah_token.add_tag blah_tag
    assert template.nonstrict_match [@tok_a, blah_token, @tok_b]
  end
end