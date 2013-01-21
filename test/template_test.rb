require 'helper'

class TestTemplate < MiniTest::Unit::TestCase
  def setup 
    @template = Onigiri::Template.new([:scalar_measurement, :measurement], :some_parser)
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
    matchset = @template.matches? [@tok_a, @tok_b]
    assert_equal [@tag_a, @tag_b], matchset.matches
  end

  def test_template_does_not_match_tokens_in_wrong_order
    refute @template.matches? [@tok_b, @tok_a]
  end

  def test_template_match_fails_if_unmatched_pattern_parts_exist
    refute @template.matches? [@tok_a]
  end

  def test_template_match_allows_optional_pattern_elements_to_not_match
    not_optional = Onigiri::Template.new([:scalar_measurement, :ingredient, :measurement], :some_parser)
    optional     = Onigiri::Template.new([:scalar_measurement, :ingredient?, :measurement], :some_parser)
    assert optional.matches?([@tok_a, @tok_b])
    refute not_optional.matches?([@tok_a, @tok_b])
  end
end