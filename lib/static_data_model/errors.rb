# frozen_string_literal: true

# Namespace for errors
module Errors
  # To be raised when a record is not found, i.e. by .find
  class RecordNotFound < StandardError; end
end
