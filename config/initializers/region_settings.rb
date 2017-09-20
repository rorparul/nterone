::TopLevelDomain = `hostname`.match(/\w+$/).to_s

# NOTE: Remove RegionalPhoneNumberForOnlineMarketing variable

::RegionalPhoneNumberForOnlineMarketing = case TopLevelDomain
                                          when 'ca'
                                            '613-317-2480'
                                          when 'com'
                                            '703-991-5185'
                                          when 'la'
                                            '+507 6924-8051'
                                          else
                                            '123-456-7890'
                                          end

::RegionalPhoneNumber = case TopLevelDomain
                        when 'ca'
                          '613-317-2480'
                        when 'com'
                          '703-972-2288'
                        when 'la'
                          '+507 6924-8051'
                        else
                          '123-456-7890'
                        end
