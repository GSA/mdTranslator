module ADIWG
   module Mdtranslator
      module Readers
         module Iso19115_3
            VERSION = "1.0.0"

            # common xpaths
            CODE_XPATH = ".//mcc:code//gco:CharacterString"
            CODESPACE_XPATH = ".//mcc:codeSpace//gco:CharacterString"
            DESC_XPATH = ".//mcc:description//gco:CharacterString"
            TITLE_XPATH = ".//cit:title//gco:CharacterString"

         end
      end
   end
end
