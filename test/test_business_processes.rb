#
# Copyright (c) 2013 figo GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require "flt"
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require_relative "../lib/figo"

class FigoTest < MiniTest::Unit::TestCase
  def setup
    @sut = Figo::Session.new(CONFIG["ACCESS_TOKEN"])
  end

  ##   Business Process System
  def test_create_and_begin_process
    process = Figo::Process.new(@sut, { email: "example@example.com", password: "password", redirect_uri: "http://127.0.0.1", state: "123", steps: [] })

    execption = assert_raises(Figo::Error) { @sut.create_process(process) }
    assert "Missing, invalid or expired access token.", execption.message
    # assert @sut.create_process(process)
    # assert_nil @sut.start_task(@sut.create_process(process))
  end
end
