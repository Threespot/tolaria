# Raised when Tolaria can't find a template that it expected the
# developer to provide
class Tolaria::MissingAdminTemplate < ActionView::MissingTemplate; end

# Raised when the developer misconfigures Tolaria or a model somehow
class Tolaria::ConfigurationError < RuntimeError; end

