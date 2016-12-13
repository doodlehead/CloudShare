require 'paperclip/media_type_spoof_detector'
#disable spoof protection because its useless
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end