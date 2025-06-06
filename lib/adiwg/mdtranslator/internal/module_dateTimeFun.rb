# date, dateTime methods
# for ADIwg readers and writers

# History:
#  Stan Smith 2018-02-20 added tests for valid date and time formats
# 	Stan Smith 2013-12-06 added support for fractional seconds
# 	Stan Smith 2013-09-26 original script

require 'date'

module AdiwgDateTimeFun

   def self.dateTimeFromString(inDateTime)

      inDate, inTime = inDateTime.split('T')

      # test for valid date before passing to formatter
      y, m, d = inDate.split('-')
      m = 1 if m.nil?
      d = 1 if d.nil?
      haveDate = Date.valid_date?(y.to_i, m.to_i, d.to_i)
      return nil, 'ERROR' unless haveDate

      # test for valid time before passing to formatter
      # complete time regex /^[0-2]\d:[0-5]\d:[0-5]\d\.\d+([+-][0-2]\d:[0-5]\d|[zZ])/
      # concatenate each permitted time format
      unless inTime.nil?
         timeReg = /^[0-2]\d|^[0-2]\d([+-][0-2]\d:[0-5]\d|[zZ])|^[0-2]\d:[0-5]\d|^[0-2]\d:[0-5]\d([+-][0-2]\d:[0-5]\d|[zZ])|^[0-2]\d:[0-5]\d:[0-5]\d|^[0-2]\d:[0-5]\d:[0-5]\d([+-][0-2]\d:[0-5]\d|[zZ])|^[0-2]\d:[0-5]\d:[0-5]\d\.\d+|^[0-2]\d:[0-5]\d:[0-5]\d\.\d+([+-][0-2]\d:[0-5]\d|Z)/
         return nil, 'ERROR' unless (timeReg =~ inTime) == 0
      end

      hFormats = {'YMDhmsLZ' => '%Y-%m-%dT%H:%M:%S.%L%z',
                  'YMDhmsL' => '%Y-%m-%dT%H:%M:%S.%L',
                  'YMDhmsZ' => '%Y-%m-%dT%H:%M:%S%z',
                  'YMDhms' => '%Y-%m-%dT%H:%M:%S',
                  'YMDhmZ' => '%Y-%m-%dT%H:%M%z',
                  'YMDhm' => '%Y-%m-%dT%H:%M',
                  'YMDhZ' => '%Y-%m-%dT%H%z',
                  'YMDh' => '%Y-%m-%dT%H',
                  'YMD' => '%Y-%m-%d',
                  'YM' => '%Y-%m',
                  'Y' => '%Y'}
      hFormats.each do |dateResolution, format|
         myDateTime = DateTime.strptime(inDateTime, format) rescue false
         return myDateTime, dateResolution if myDateTime
      end

      return nil, 'ERROR'
   end

   def self.stringDateFromDateTime(myDateTime, dateResolution)
      s = case dateResolution
             when 'YMDhmsLZ', 'YMDhmsL', 'YMDhmsZ', 'YMDhms',
                'YMDhmZ', 'YMDhm', 'YMDhZ', 'YMDh', 'YMD'
                myDateTime.strftime('%Y-%m-%d')
             when 'YM'
                myDateTime.strftime('%Y-%m')
             when 'Y'
                myDateTime.strftime('%Y')
             else
                'ERROR'
          end

      return s
   end

   def self.stringDateTimeFromDateTime(myDateTime, dateResolution)
      s = case dateResolution
             when 'YMDhmsLZ'
                myDateTime.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
             when 'YMDhmsL'
                myDateTime.strftime('%Y-%m-%dT%H:%M:%S.%L')
             when 'YMDhmsZ'
                myDateTime.strftime('%Y-%m-%dT%H:%M:%S%:z')
             when 'YMDhms', 'YMD', 'YM', 'Y'
                myDateTime.strftime('%Y-%m-%dT%H:%M:%S')
             when 'YMDhmZ'
                myDateTime.strftime('%Y-%m-%dT%H:%M%:z')
             when 'YMDhm'
                myDateTime.strftime('%Y-%m-%dT%H:%M')
             when 'YMDhZ'
                myDateTime.strftime('%Y-%m-%dT%H%:z')
             when 'YMDh'
                myDateTime.strftime('%Y-%m-%dT%H')
             else
                'ERROR'
          end

      return s
   end

   def self.stringTimeFromDateTime(myDateTime, dateResolution)
      s = case dateResolution
             when 'YMDhmsLZ'
                myDateTime.strftime('%H:%M:%S.%L%:z')
             when 'YMDhmsL'
                myDateTime.strftime('%H:%M:%S.%L')
             when 'YMDhmsZ'
                myDateTime.strftime('%H:%M:%S%:z')
             when 'YMDhms'
                myDateTime.strftime('%H:%M:%S')
             when 'YMDhmZ'
                myDateTime.strftime('%H:%M%:z')
             when 'YMDhm'
                myDateTime.strftime('%H:%M')
             when 'YMDhZ'
                myDateTime.strftime('%H%:z')
             when 'YMDh'
                myDateTime.strftime('%H')
             else
                'ERROR'
          end

      return s
   end

   def self.convertDurationToNamedGroup(sDuration)
      # named grouping pattern for xsd:duration
      # with format of P[n]Y[n]M[n]DT[n]H[n]M[n]S
      pattern = %r{(?<sign>P)(?:(?<years>\d+)Y)?(?:(?<months>\d+)M)?(?:(?<days>\d+)D)?(?:T(?<hours>\d+)H)?(?:(?<minutes>\d+)M)?(?:(?<seconds>\d+)S)?}

      matches = pattern.match(sDuration)
      matches.nil? ? matches : matches.named_captures
   end

   def self.writeDuration(hDuration)
      # format P[n]Y[n]M[n]DT[n]H[n]M[n]S
      # example P1DT12H
      sDuration = 'P'

      unless hDuration[:years] == 0
         sDuration += hDuration[:years].to_s + 'Y'
      end

      unless hDuration[:months] == 0
         sDuration += hDuration[:months].to_s + 'M'
      end

      unless hDuration[:days] == 0
         sDuration += hDuration[:days].to_s + 'D'
      end

      haveTime = false

      unless hDuration[:hours] == 0
         unless haveTime
            sDuration += 'T'
            haveTime = true
         end
         sDuration += hDuration[:hours].to_s + 'H'
      end

      unless hDuration[:minutes] == 0
         unless haveTime
            sDuration += 'T'
            haveTime = true
         end
         sDuration += hDuration[:minutes].to_s + 'M'
      end

      unless hDuration[:seconds] == 0
         unless haveTime
            sDuration += 'T'
         end
         sDuration += hDuration[:seconds].to_s + 'S'
      end

      return sDuration
   end

   def self.stringDateFromDateObject(obj)

      date = obj[:date]
      if date.nil?
         date = obj[:dateTime]
      end
      dateRes = obj[:dateResolution]
      unless date.nil?
         dateStr = stringDateFromDateTime(date, dateRes)
      end
      return dateStr

   end

   def self.stringDateTimeFromDateObject(obj)

      date = obj[:date]
      if date.nil?
         date = obj[:dateTime]
      end
      dateRes = obj[:dateResolution]
      unless date.nil?
         case dateRes
            when 'Y', 'YM', 'YMD'
               dateStr = stringDateFromDateTime(date, dateRes)
            else
               dateStr = stringDateTimeFromDateTime(date, dateRes)
         end
      end

      return dateStr
   end

end
