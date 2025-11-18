#!/usr/bin/env ruby

module BelinvestbankApi
  def parse_keyLang(text)
      if text =~ /keyLang":\[([^\]]+)/ then
        str = $1
        str.split(',').map {|e| e.to_i}
      end
  end
  module_function :parse_keyLang
end

def test!
  puts "..Testing keylang parser input and output"
  input = File.read("testdata/login.belinvestbank.by_signin")
  output = BelinvestbankApi.parse_keyLang(input)
  expected = [50, 82, 76, 46, 73, 105, 1070, 1093, 112, 1052, 70, 115, 1099, 1048, 51, 1051, 108, 1053, 1080, 120, 1072, 49, 1091, 98, 53, 55, 121, 1056, 1101, 65, 116, 1045, 1097, 85, 103, 1057, 1058, 1098, 122, 74, 1049, 97, 1044, 56, 1069, 77, 88, 1087, 114, 1061, 100, 119, 1089, 1083, 106, 1096, 1064, 1073, 1090, 1078, 111, 67, 1103, 1079, 104, 1059, 86, 52, 1067, 1102, 79, 1074, 90, 72, 110, 1081, 1068, 75, 1043, 1040, 1054, 84, 101, 1042, 69, 1084, 1086, 1071, 1082, 1063, 48, 1062, 71, 1050, 1075, 1076, 109, 45, 1041, 78, 113, 57, 83, 87, 102, 1046, 95, 1085, 89, 118, 1095, 66, 1094, 1060, 1092, 54, 1047, 1100, 1088, 1065, 1077, 99, 1055, 68, 117, 107, 80, 81, 1066]
  if output != expected
    puts "FAIL"
    raise
  else
    puts "PASS"
  end
end

test! if __FILE__ == $PROGRAM_NAME
