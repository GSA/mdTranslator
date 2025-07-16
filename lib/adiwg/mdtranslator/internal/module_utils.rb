# frozen_string_literal: true

require 'net/http'

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

    nilReason = nil
    nilReasonAttrs = ['gco:nilReason', 'indeterminatePosition']
    nilReasonAttrs.each do |nr|
      nr = elem.attr(nr)
      nilReason = nr unless nr.nil?
    end
    return false, nilReason if nilReason.nil?

    nilReason.downcase! # modifies in-place
    nilReason.strip!

    # nil reason enumeration values
    nilReasons = %w[inapplicable missing template unknown withheld]
    return true, nilReason if nilReasons.include? nilReason

    # indeterminatePosition enumeration values
    # xsd: https://schemas.opengis.net/gml/3.2.1/temporal.xsd
    indeterminateReasons = %w[after before now unknown]
    return true, nilReason if indeterminateReasons.include? nilReason

    # non-spec but found in production nilReasons
    nonSpecNilReasons = %w[unavailable]
    return true, nilReason if nonSpecNilReasons.include? nilReason

    # regex patterns
    nilRegexs = [/other:\w{2,}/, %r{([a-zA-Z][a-zA-Z0-9\-+.]*:|\.\./|\./|#).*}]
    nilRegexs.each do |regex|
      return true, nilReason unless regex.match(nilReason).nil?
    end

    [false, nilReason]
  end

  def self.valid_nil_reason(elem, hResponseObj)
    # true means the element has a present and acceptable nilReason
    # false means it doesn't

    validNil, nilReason = check_nil_reason(elem)
    return false if validNil == false

    # this is only used in ISO19115-2_datagov for now. TODO: update it to reflect
    # whatever reader it is
    msg = "INFO: ISO19115-2 reader: element \'#{elem.name}\' "\
      "contains acceptable nilReason: \'#{nilReason}\'"
    hResponseObj[:readerValidationMessages] << msg
    true
  end

  def self.add_iso19115_namespaces(xmlDoc)
    # some ISO19115 docs don't declare the required namespaces at the root
    # but rather on each element. nokogiri doesn't like that so registering
    # them here.
    ns = { gmi: 'http://www.isotc211.org/2005/gmi',
           gmd: 'http://www.isotc211.org/2005/gmd',
           gco: 'http://www.isotc211.org/2005/gco',
           gml: 'http://www.opengis.net/gml/3.2',
           gsr: 'http://www.isotc211.org/2005/gsr',
           gss: 'http://www.isotc211.org/2005/gss',
           gst: 'http://www.isotc211.org/2005/gst',
           gmx: 'http://www.isotc211.org/2005/gmx',
           gfc: 'http://www.isotc211.org/2005/gfc',
           srv: 'http://www.isotc211.org/2005/srv',
           xlink: 'http://www.w3.org/1999/xlink',
           xsi: 'http://www.w3.org/2001/XMLSchema-instance' }

    ns.each do |key, value|
      xmlDoc.root.add_namespace_definition(key.to_s, value)
    end
  end

  def self.fetch_doc(urlStr, limit = 10)
    # fetch the input document. follows [limit] redirects.
    return nil if limit.zero?

    url = URI.parse(urlStr)
    req = Net::HTTP::Get.new(url.path)
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }
    case response
    when Net::HTTPSuccess     then response.body
    when Net::HTTPRedirection then fetch_doc(response['location'], limit - 1)
    end
  end

  def self.convert_xlink_to_elem(link)
    # follows xlink href and converts xmlstr to elem root
    # this function is intended for processing xlink:href docs
    # where the element is substituted for a link to the xml doc
    # containing that element
    xmlStr = AdiwgUtils.fetch_doc(link)
    Nokogiri::XML(xmlStr, &:strict).root
  rescue StandardError
    # logging occurs in the calling function
    nil
  end

  def self.empty_string_to_nil(input)
    # writing to json with nils cause the field to not populate
    # but empty string do
    # { "data": nil } => {} but { "data": "" } => { "data": "" }
    return nil if input.is_a?(String) && input.empty?

    input
  end
end
