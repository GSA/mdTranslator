# frozen_string_literal: true

module AdiwgUtils
   def self.reconcile_hashes(hashA, hashB)
      # merges hashes by value "truthyness"
      # the "falsely" values we're looking to replace
      # are nil, false, and empty {} & []
      # there shouldn't be any situation with 2 truthy values
      hashA.merge(hashB) do |_, oldval, newval|
         (oldval.respond_to?(:empty?) && oldval.empty?) || !oldval ? newval : oldval
      end
   end
end
