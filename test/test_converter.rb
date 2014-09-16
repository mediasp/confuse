# coding: utf-8

class TestConverter < MiniTest::Unit::TestCase
  def test_string
    converter = Confuse::Converter[String]

    assert_equal '1', converter.call(1)
    assert_equal '1.0', converter.call(1.0)
    assert_equal 'true', converter.call(true)
    assert_equal 'false', converter.call(false)
    assert_equal 'foo', converter.call('foo')
  end

  def test_fixnum
    converter = Confuse::Converter[Fixnum]

    assert_equal 1, converter.call(1)
    assert_equal 1, converter.call('1')
    assert_raises(Confuse::Errors::Invalid) { converter.call('1.0') }
    assert_raises(Confuse::Errors::Invalid) { converter.call('1.0.0') }
    assert_raises(Confuse::Errors::Invalid) { converter.call('foo') }
  end

  def test_float
    converter = Confuse::Converter[Float]

    assert_equal 1.0, converter.call(1.0)
    assert_equal 1.0, converter.call(1)
    assert_equal 1.0, converter.call('1')
    assert_equal 1.0, converter.call('1.0')
    assert_raises(Confuse::Errors::Invalid) { converter.call('1.0.0') }
    assert_raises(Confuse::Errors::Invalid) { converter.call('foo') }
  end

  def test_bool
    converter = Confuse::Converter[:bool]

    assert_equal true, converter.call(true)
    assert_equal false, converter.call(false)
    assert_equal true, converter.call('true')
    assert_equal false, converter.call('false')
    assert_raises(Confuse::Errors::Invalid) { converter.call('foo') }
  end

  def test_array
    converter = Confuse::Converter[Array]

    assert_equal %w(foo bar), converter.call(%w(foo bar))
    assert_equal %w(foo bar), converter.call('foo,bar')
    assert_raises(Confuse::Errors::Invalid) { converter.call('foo') }
  end
end
