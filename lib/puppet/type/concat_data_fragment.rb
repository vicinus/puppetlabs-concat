Puppet::Type.newtype(:concat_data_fragment) do
  @doc = <<-DOC
    @summary
      Manages the data fragment.

    @example
      concat_data_fragment { "uniqe_name_${::fqdn}":
        target => 'fragment title',
        data  => 'value1',
      }
  DOC

  newparam(:name, namevar: true) do
    desc 'Name of resource.'
  end

  newparam(:target) do
    desc <<-DOC
      Required. Specifies the destination fragment of the data fragment. Valid options: a string containing the title of the parent
      concat_fragment resource.
    DOC

    validate do |value|
      raise ArgumentError, _('Target must be a String') unless value.is_a?(String)
    end
  end

  newparam(:order) do
    desc <<-DOC
      Reorders your data fragments within the data array. Data fragments that share the same order number are ordered by name.
    DOC

    defaultto '10'
    validate do |val|
      raise Puppet::ParseError, _('$order is not a string.') unless val.is_a?(String)
      raise Puppet::ParseError, _('Order cannot contain \'/\', \':\', or \'\\n\'.') if val.to_s =~ %r{[:\n\/]}
    end
  end

  newparam(:data) do
    desc <<-DOC
      data value
    DOC
  end

  autorequire(:file) do
    found = catalog.resources.select do |resource|
      next unless resource.is_a?(Puppet::Type.type(:concat_fragment))

      resource.title == self[:target]
    end

    if found.empty?
      warning "Target Concat_Fragment with title '#{self[:target]}' not found in the catalog"
    end
  end

  validate do
    # Check if target is set
    raise Puppet::ParseError, _("No 'target' set") unless self[:target]
  end
end
