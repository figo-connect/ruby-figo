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
  i_suck_and_my_tests_are_order_dependent!()

  def setup
    @sut = Figo::Session.new(CONFIG["ACCESS_TOKEN"])
  end

  ##  Payments
  # Retrieve all Payments
  def test_retrieve_all_payments
    payments = @sut.payments

    assert payments.length > 0
  end

  # Retrieve all Payments of one Account
  def test_retrieve_all_payments_for_one_account
    refute_nil @sut.payments("A1.1")
  end

  # Retrieve one Payment of one Account
  def test_retrieve_one_payment_of_one_account
    payments = @sut.payments("A1.1")

    refute_nil @sut.get_payment("A1.1", payments[-1].payment_id).purpose
  end

  # Retrieve Payment Proposals
  def test_retreive_payment_proposals
    assert @sut.get_payment_proposals.length > 0
  end

  # Create a Single Payment
  def test_create_a_single_payment
    added_payment = @sut.add_payment(Figo::Payment.new(@sut, {account_id: "A1.1", type: "Transfer", account_number: "4711951501", bank_code: "90090042", name: "figo", purpose: "Thanks for all the fish.", amount: 0.89}))

    refute_nil added_payment.payment_id
    assert_equal added_payment.account_id, "A1.1"
    assert_equal added_payment.bank_name, "Demobank"
    assert_equal added_payment.amount, 0.89
  end

  # Submit Payment to Bank Server and test tasks
  def test_submit_payment_to_bank_server
    payment = Figo::Payment.new(@sut, {account_id: "A1.1", type: "Transfer", account_number: "4711951501", bank_code: "90090042", name: "figo", purpose: "Thanks for all the fish.", amount: 0.89});

    payment = @sut.add_payment(payment)
    assert payment

    execption = assert_raises(Figo::Error) { @sut.submit_payment(payment, "M1.1", "string", "http://127.0.0.1") }
    assert "Missing, invalid or expired access token.", execption.message
    # task = @sut.submit_payment(payment, "M1.1", "string", "http://127.0.0.1")
    #
    # assert_match task, /https:/
    # refute_nil @sut.start_task(task)
    # assert @sut.get_task_state(task)
    # refute_nil @sut.cancel_task(task)
  end

  # Modify a Single Payment
  def test_modify_a_single_payment
    payment = @sut.payments("A1.1")[-1]
    payment.purpose = "new purpose"

    new_payment = @sut.modify_payment(payment)

    assert_equal payment.purpose, new_payment.purpose
  end

  # Delete Payment
  def test_delete_payment
    payment = @sut.payments("A1.1")[-1]

    @sut.remove_payment(payment)

    assert_nil @sut.get_payment("A1.1", payment.payment_id)
  end
end
