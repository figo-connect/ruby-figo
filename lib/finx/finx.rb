# FinX API support
# 
# This module provides support for the finX API. The figo API is stated as legacy by finleap.
require_relative 'payment'

module FinX
  FINX_API_HOST = 'finx-s.finleap.cloud'

  include FinX::Payment
end
