# frozen_string_literal: true

module AdiwgUtils
  def self.reconcile_hashes(hashA, hashB)
    # merges hashes by value "truthyness"
    # the "falsely" values we're looking to replace
    # are nil, false, and empty {} & []
    # there shouldn't be any situation with 2 truthy values

    # CI_Individual/Organisation use the newContact internal hash
    # they ^ can have contactInfo elements as children which also use newContact
    # but when writing these contact hashes are used as 1. that's why we merge.
    hashA.merge(hashB) do |_, oldval, newval|
      (oldval.respond_to?(:empty?) && oldval.empty?) || !oldval ? newval : oldval
    end
  end

  def self.consolidate_iso191152_rparties(arr)
    # groups the input array of responsibility hashes by roleName and combines roleExtents and parties
    output = arr.map { |h| { roleName: h[:roleName], roleExtents: [], parties: [] } }.compact.uniq
    arr.each do |h|
      res = output.find { |r| r[:roleName] == h[:roleName] } # this will edit the hash in-place in the array
      res[:roleExtents] += h[:roleExtents]
      res[:parties] += h[:parties]
    end
    output
  end

  def self.check_nil_reason(elem)
    # nilreason documentation: https://www.isotc211.org/2005/gml/basicTypes.xsd

    nilReason = elem.attr('gco:nilReason')
    return false if nilReason.nil?

    nilReason.downcase! # modifies in-place

    # enumeration values
    nilReasons = %w[inapplicable missing template unknown withheld]
    return true if nilReasons.include? nilReason

    # non-spec but found in production nilReasons
    nonSpecNilReasons = %w[unavailable]
    return true if nonSpecNilReasons.include? nilReason

    # regex patterns
    nilRegexs = [/other:\w{2,}/, %r{([a-zA-Z][a-zA-Z0-9\-+.]*:|\.\./|\./|#).*}]
    nilRegexs.each do |regex|
      return true unless regex.match(nilReason).nil?
    end

    false
  end

  def self.valid_nil_reason(elem, hResponseObj)
    # true means the element has a present and acceptable nilReason
    # false means it doesn't

    return false unless check_nil_reason(elem)

    # this is only used in ISO19115-2_datagov for now. TODO: update it to reflect
    # whatever reader it is
    msg = "INFO: ISO19115-2 reader: element \'#{elem.name}\' "\
      "contains acceptable nilReason: \'#{elem.attr('gco:nilReason')}\'"
    hResponseObj[:readerValidationMessages] << msg
    true
  end
end
