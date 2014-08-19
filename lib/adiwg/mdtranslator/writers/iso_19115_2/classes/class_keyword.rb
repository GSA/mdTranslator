# ISO <<Class>> MD_Keyword
# writer output in XML

# History:
# 	Stan Smith 2013-09-18 original script
#   Stan Smith 2014-07-08 modify require statements to function in RubyGem structure

require 'code_keywordType'
require 'class_citation'

class MD_Keywords

	def initialize(xml)
		@xml = xml
	end

	def writeXML(hDKeyword)

		# classes used
		citationClass = CI_Citation.new(@xml)
		keywordCode = MD_KeywordTypeCode.new(@xml)

		@xml.tag!('gmd:MD_Keywords') do

			# keywords - keyword - required
			aKeywords = hDKeyword[:keyword]
			if aKeywords.empty?
				@xml.tag!('gmd:keyword', {'gco:nilReason' => 'missing'})
			else
				aKeywords.each do |keyword|
					@xml.tag!('gmd:keyword') do
						@xml.tag!('gco:CharacterString', keyword)
					end
				end
			end

			# keywords - type - MD_KeywordTypeCode
			s = hDKeyword[:keywordType]
			if !s.nil?
				@xml.tag!('gmd:type') do
					keywordCode.writeXML(s)
				end
			elsif $showEmpty
				@xml.tag!('gmd:type')
			end

			hKeyCitation = hDKeyword[:keyTheCitation]
			keyLink = hDKeyword[:keyTheLink]
			if !hKeyCitation.empty?

				# thesaurus - web link - attribute optional
				attributes = {}
				attributes['xlink:href'] = keyLink if keyLink
				@xml.tag!('gmd:thesaurusName', attributes) do

					# thesaurus - citation - CI_Citation (w/o responsible party)
					citationClass.writeXML(hKeyCitation)

				end

			elsif $showEmpty
				@xml.tag!('gmd:thesaurusName')
			end

		end

	end

end

