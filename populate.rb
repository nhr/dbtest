#!/bin/env ruby
# -*- coding: utf-8 -*-

require 'benchmark'
require 'mysql'

def populate_database
  # We'll limit the table to 2000 unique last names
  @last_names = []

  # We'll limit the table to 200 unique cities per country
  @cities = {}

  # And we'll do one postcode per city
  @postcodes = {}

  # Make the insert statement
  @sth = @dbh.prepare "INSERT INTO REALLY_BIG_TABLE (NAME_FIRST, NAME_MI, NAME_LAST, ADDR_ST1, ADDR_ST2, ADDR_CITY, ADDR_STATE, ADDR_POSTCODE, ADDR_COUNTRY, ADDR_PHONE, ALT_ST1, ALT_ST2, ALT_CITY, ALT_STATE, ALT_POSTCODE, ALT_COUNTRY, ALT_PHONE, FAVORITE_COLOR, FAVORITE_FLAVOR) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"


  # Throw in 2 million rows
  # Expectation: this is not super fast because of all the random
  # number generation. Also, forcing a commit every 1000 is a memory
  # and performance tradeoff
  Benchmark.bm(20) do |x|
    x.report("for:") {
      for i in 0..2000000
        first_name = varchar(32)
        mi = varchar(1)
        last_name = get_last_name(2000)
        addr_st1 = varchar(32)
        addr_st2 = varchar(32)
        addr_country = get_country
        addr_state = get_state(addr_country)
        addr_city = get_city(addr_country, 200)
        addr_postcode = get_postcode(addr_country, addr_city)
        addr_phone = get_phone
        alt_st1 = varchar(32)
        alt_st2 = varchar(32)
        alt_country = get_country
        alt_state = get_state(alt_country)
        alt_city = get_city(alt_country, 200)
        alt_postcode = get_postcode(alt_country, alt_city)
        alt_phone = get_phone
        color = get_color
        flavor = get_flavor
        @sth.execute first_name, mi, last_name, addr_st1, addr_st2, addr_city, addr_state, addr_postcode, addr_country, addr_phone, alt_st1, alt_st2, alt_city, alt_state, alt_postcode, alt_country, alt_phone, color, flavor
        if i % 1000 == 0
          @dbh.commit
          puts "Record #{i}"
        end
      end
    }
  end

  # Lock it in
  @dbh.commit
end

def alpha
  @alpha ||= [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
end

def numeric
  @numeric ||= ('0'..'9').to_a
end

def alphanumeric
  @alphanumeric ||= [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
end

def varchar(maxlength, char_source=:alpha)
  char_list = self.send(char_source)

  if maxlength == 1
    return char_list[rand(char_list.length)]
  end

  # Min length 4 characters
  len = 4 + rand(maxlength - 3)
  (0...len).map{ char_list[rand(char_list.length)] }.join
end

def get_last_name(max_names)
  name_index = rand(max_names)
  if @last_names[name_index].nil?
    @last_names[name_index] = varchar(32)
  end
  @last_names[name_index]
end

def get_country
  countries.keys[rand(countries.keys.length)]
end

def get_state(country)
  if country == 'US'
    return states[rand(states.length)]
  end
  nil
end

def get_city(country, max_cities)
  unless @cities.has_key?(country)
    @cities[country] = []
  end
  city_index = rand(max_cities)
  if @cities[country][city_index].nil?
    @cities[country][city_index] = varchar(32)
  end
  @cities[country][city_index]
end

def get_postcode(country, city)
  postkey = [country, city].join('::')
  unless @postcodes.has_key?(postkey)
    if country == 'US'
      code = varchar(5, :numeric)
      if code.length == 4
        code = '0' + code
      end
      @postcodes[postkey] = code
    else
      @postcodes[postkey] = varchar(16, :alphanumeric)
    end
  end
  @postcodes[postkey]
end

def get_phone
  len = 7 + rand(7)
  (0...len).map{ numeric[rand(numeric.length)] }.join
end

def get_color
  rand(colors.length)
end

def get_flavor
  rand(flavors.length)
end

def colors
  @colors ||= %w{RED ORANGE YELLOW GREEN BLUE INDIGO VIOLET}
end

def flavors
  @flavors ||= %w{VANILLA CHOCOLATE STRAWBERRY COFFEE}
end

def states
  @states ||= ['AK', 'AL', 'AR', 'AS', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'GU', 'HI', 'IA', 'ID',
'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MH', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY”,
“OH', 'OK', 'OR', 'PA', 'PR', 'PW', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY']
end

def countries
  @countries ||= {
    'AF'=>'Afghanistan',
    'AL'=>'Albania',
    'DZ'=>'Algeria',
    'AS'=>'American Samoa',
    'AD'=>'Andorra',
    'AO'=>'Angola',
    'AI'=>'Anguilla',
    'AQ'=>'Antarctica',
    'AG'=>'Antigua And Barbuda',
    'AR'=>'Argentina',
    'AM'=>'Armenia',
    'AW'=>'Aruba',
    'AU'=>'Australia',
    'AT'=>'Austria',
    'AZ'=>'Azerbaijan',
    'BS'=>'Bahamas',
    'BH'=>'Bahrain',
    'BD'=>'Bangladesh',
    'BB'=>'Barbados',
    'BY'=>'Belarus',
    'BE'=>'Belgium',
    'BZ'=>'Belize',
    'BJ'=>'Benin',
    'BM'=>'Bermuda',
    'BT'=>'Bhutan',
    'BO'=>'Bolivia',
    'BA'=>'Bosnia And Herzegovina',
    'BW'=>'Botswana',
    'BV'=>'Bouvet Island',
    'BR'=>'Brazil',
    'IO'=>'British Indian Ocean Territory',
    'BN'=>'Brunei',
    'BG'=>'Bulgaria',
    'BF'=>'Burkina Faso',
    'BI'=>'Burundi',
    'KH'=>'Cambodia',
    'CM'=>'Cameroon',
    'CA'=>'Canada',
    'CV'=>'Cape Verde',
    'KY'=>'Cayman Islands',
    'CF'=>'Central African Republic',
    'TD'=>'Chad',
    'CL'=>'Chile',
    'CN'=>'China',
    'CX'=>'Christmas Island',
    'CC'=>'Cocos (Keeling) Islands',
    'CO'=>'Columbia',
    'KM'=>'Comoros',
    'CG'=>'Congo',
    'CK'=>'Cook Islands',
    'CR'=>'Costa Rica',
    'CI'=>'Cote D\'Ivorie (Ivory Coast)',
    'HR'=>'Croatia (Hrvatska)',
    'CU'=>'Cuba',
    'CY'=>'Cyprus',
    'CZ'=>'Czech Republic',
    'CD'=>'Democratic Republic Of Congo (Zaire)',
    'DK'=>'Denmark',
    'DJ'=>'Djibouti',
    'DM'=>'Dominica',
    'DO'=>'Dominican Republic',
    'TP'=>'East Timor',
    'EC'=>'Ecuador',
    'EG'=>'Egypt',
    'SV'=>'El Salvador',
    'GQ'=>'Equatorial Guinea',
    'ER'=>'Eritrea',
    'EE'=>'Estonia',
    'ET'=>'Ethiopia',
    'FK'=>'Falkland Islands (Malvinas)',
    'FO'=>'Faroe Islands',
    'FJ'=>'Fiji',
    'FI'=>'Finland',
    'FR'=>'France',
    'FX'=>'France, Metropolitan',
    'GF'=>'French Guinea',
    'PF'=>'French Polynesia',
    'TF'=>'French Southern Territories',
    'GA'=>'Gabon',
    'GM'=>'Gambia',
    'GE'=>'Georgia',
    'DE'=>'Germany',
    'GH'=>'Ghana',
    'GI'=>'Gibraltar',
    'GR'=>'Greece',
    'GL'=>'Greenland',
    'GD'=>'Grenada',
    'GP'=>'Guadeloupe',
    'GU'=>'Guam',
    'GT'=>'Guatemala',
    'GN'=>'Guinea',
    'GW'=>'Guinea-Bissau',
    'GY'=>'Guyana',
    'HT'=>'Haiti',
    'HM'=>'Heard And McDonald Islands',
    'HN'=>'Honduras',
    'HK'=>'Hong Kong',
    'HU'=>'Hungary',
    'IS'=>'Iceland',
    'IN'=>'India',
    'ID'=>'Indonesia',
    'IR'=>'Iran',
    'IQ'=>'Iraq',
    'IE'=>'Ireland',
    'IL'=>'Israel',
    'IT'=>'Italy',
    'JM'=>'Jamaica',
    'JP'=>'Japan',
    'JO'=>'Jordan',
    'KZ'=>'Kazakhstan',
    'KE'=>'Kenya',
    'KI'=>'Kiribati',
    'KW'=>'Kuwait',
    'KG'=>'Kyrgyzstan',
    'LA'=>'Laos',
    'LV'=>'Latvia',
    'LB'=>'Lebanon',
    'LS'=>'Lesotho',
    'LR'=>'Liberia',
    'LY'=>'Libya',
    'LI'=>'Liechtenstein',
    'LT'=>'Lithuania',
    'LU'=>'Luxembourg',
    'MO'=>'Macau',
    'MK'=>'Macedonia',
    'MG'=>'Madagascar',
    'MW'=>'Malawi',
    'MY'=>'Malaysia',
    'MV'=>'Maldives',
    'ML'=>'Mali',
    'MT'=>'Malta',
    'MH'=>'Marshall Islands',
    'MQ'=>'Martinique',
    'MR'=>'Mauritania',
    'MU'=>'Mauritius',
    'YT'=>'Mayotte',
    'MX'=>'Mexico',
    'FM'=>'Micronesia',
    'MD'=>'Moldova',
    'MC'=>'Monaco',
    'MN'=>'Mongolia',
    'MS'=>'Montserrat',
    'MA'=>'Morocco',
    'MZ'=>'Mozambique',
    'MM'=>'Myanmar (Burma)',
    'NA'=>'Namibia',
    'NR'=>'Nauru',
    'NP'=>'Nepal',
    'NL'=>'Netherlands',
    'AN'=>'Netherlands Antilles',
    'NC'=>'New Caledonia',
    'NZ'=>'New Zealand',
    'NI'=>'Nicaragua',
    'NE'=>'Niger',
    'NG'=>'Nigeria',
    'NU'=>'Niue',
    'NF'=>'Norfolk Island',
    'KP'=>'North Korea',
    'MP'=>'Northern Mariana Islands',
    'NO'=>'Norway',
    'OM'=>'Oman',
    'PK'=>'Pakistan',
    'PW'=>'Palau',
    'PA'=>'Panama',
    'PG'=>'Papua New Guinea',
    'PY'=>'Paraguay',
    'PE'=>'Peru',
    'PH'=>'Philippines',
    'PN'=>'Pitcairn',
    'PL'=>'Poland',
    'PT'=>'Portugal',
    'PR'=>'Puerto Rico',
    'QA'=>'Qatar',
    'RE'=>'Reunion',
    'RO'=>'Romania',
    'RU'=>'Russia',
    'RW'=>'Rwanda',
    'SH'=>'Saint Helena',
    'KN'=>'Saint Kitts And Nevis',
    'LC'=>'Saint Lucia',
    'PM'=>'Saint Pierre And Miquelon',
    'VC'=>'Saint Vincent And The Grenadines',
    'SM'=>'San Marino',
    'ST'=>'Sao Tome And Principe',
    'SA'=>'Saudi Arabia',
    'SN'=>'Senegal',
    'SC'=>'Seychelles',
    'SL'=>'Sierra Leone',
    'SG'=>'Singapore',
    'SK'=>'Slovak Republic',
    'SI'=>'Slovenia',
    'SB'=>'Solomon Islands',
    'SO'=>'Somalia',
    'ZA'=>'South Africa',
    'GS'=>'South Georgia And South Sandwich Islands',
    'KR'=>'South Korea',
    'ES'=>'Spain',
    'LK'=>'Sri Lanka',
    'SD'=>'Sudan',
    'SR'=>'Suriname',
    'SJ'=>'Svalbard And Jan Mayen',
    'SZ'=>'Swaziland',
    'SE'=>'Sweden',
    'CH'=>'Switzerland',
    'SY'=>'Syria',
    'TW'=>'Taiwan',
    'TJ'=>'Tajikistan',
    'TZ'=>'Tanzania',
    'TH'=>'Thailand',
    'TG'=>'Togo',
    'TK'=>'Tokelau',
    'TO'=>'Tonga',
    'TT'=>'Trinidad And Tobago',
    'TN'=>'Tunisia',
    'TR'=>'Turkey',
    'TM'=>'Turkmenistan',
    'TC'=>'Turks And Caicos Islands',
    'TV'=>'Tuvalu',
    'UG'=>'Uganda',
    'UA'=>'Ukraine',
    'AE'=>'United Arab Emirates',
    'UK'=>'United Kingdom',
    'US'=>'United States',
    'UM'=>'United States Minor Outlying Islands',
    'UY'=>'Uruguay',
    'UZ'=>'Uzbekistan',
    'VU'=>'Vanuatu',
    'VA'=>'Vatican City (Holy See)',
    'VE'=>'Venezuela',
    'VN'=>'Vietnam',
    'VG'=>'Virgin Islands (British)',
    'VI'=>'Virgin Islands (US)',
    'WF'=>'Wallis And Futuna Islands',
    'EH'=>'Western Sahara',
    'WS'=>'Western Samoa',
    'YE'=>'Yemen',
    'YU'=>'Yugoslavia',
    'ZM'=>'Zambia',
    'ZW'=>'Zimbabwe',
  }
end

begin
  @dbh = Mysql.new ENV['OPENSHIFT_MYSQL_DB_HOST'], ENV['OPENSHIFT_MYSQL_DB_USERNAME'], ENV['OPENSHIFT_MYSQL_DB_PASSWORD'], ENV['OPENSHIFT_APP_NAME'], ENV['OPENSHIFT_MYSQL_DB_PORT'].to_i, ENV['OPENSHIFT_MYSQL_DB_SOCKET']
  @dbh.autocommit false
  populate_database
rescue Mysql::Error => e
  puts e.errno
  puts e.error
  @dbh.rollback
ensure
  @sth.close if @sth
  @dbh.close if @dbh
  exit
end
