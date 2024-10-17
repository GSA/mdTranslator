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
end
