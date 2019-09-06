# frozen_string_literal: true

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

require 'active_support/core_ext/object/to_query'

require_relative 'authentification/api_call'
require_relative 'catalog/api_call'
require_relative 'connection'
require_relative 'helpers/error'
require_relative 'helpers/https'
require_relative 'session'

module Figo
  API_ENDPOINT = 'api-preview.figo.me'

  private

  def parameterized_path(path, options)
    hash = options.delete_if { |_, v| v.nil? }
    query_params = hash.to_a.map { |e| e.join('=') }.join('&')
    query_params.empty? ? path : "#{path}?#{query_params}"
  end
end
