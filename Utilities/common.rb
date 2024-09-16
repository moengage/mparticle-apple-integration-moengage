module MPKit
  MO_MP_DEV_REPO = 'MO_MP_DEV_REPO'
  MO_MP_DEV_BRANCH = 'MO_MP_DEV_BRANCH'

  # Provides boolean data from environment variables.
  class ENVBOOL
    # All the values in environment variable that are treated as `true`.`
    TRUE_VALUES = %w[1 y Y true TRUE True].freeze

    # Check boolean value for provided environment key.
    #
    # @param [String] The key value to check.
    # @param [Bool] The default value to use if key is absent.
    # @return [Bool] The value for the key.
    def self.value(key, default = false)
      value = ENV[key]
      return default unless value
      TRUE_VALUES.include?(value)
    end
  end

  # Get development source for SDK.
  #
  # @return [Hash] Returns git repo and branch values.
  def self.dev_source
    dev_repo = ENV[MO_MP_DEV_REPO]
    dev_branch = ENV[MO_MP_DEV_BRANCH]
    return { :git => "https://github.com/moengage/#{dev_repo}.git", :branch => dev_branch } if dev_repo && dev_branch
  end
end