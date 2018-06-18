$tld = `hostname`.match(/\w+$/).to_s

::TopLevelDomain = `hostname`.match(/\w+$/).to_s

::RegionalPhoneNumber = case TopLevelDomain
                        when 'ca'
                          '613-317-2480'
                        when 'com'
                          '703-972-2288'
                        when 'in'
                          '+91-8792-444444'
                        when 'la'
                          '+507-6924-8051'
                        else
                          '123-456-7890'
                        end
