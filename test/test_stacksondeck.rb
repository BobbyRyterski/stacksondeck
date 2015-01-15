require 'tmpdir'
require 'logger'
require 'tempfile'
require 'fileutils'
require 'pathname'

require 'minitest/autorun'

require_relative '../lib/stacksondeck'



class TestStacksOnDeck < MiniTest::Test
  def setup
    @tmpdir       = Dir.mktmpdir
    @logger       = Logger.new STDERR
    @logger.level = Logger::WARN
  end

  def teardown
    FileUtils.rm_rf @tmpdir
  end

  def test_something
    assert true
  end
end