#!/bin/awk -f



BEGIN {
    # Record separator to blank line
	RS=""
	# Field separator to new line or space
	#FS=
	part_one_valid_count = 0;
	part_two_valid_count = 0;

}

{
 	print NF, "fields";
 	#print $0;
 	is_fields_missing = 0;  # 0 is false, we assume all fields record present.
 	is_fields_invalid = 0;  # 0 is false, we assume all fields are valid.

 	# Only interested in records with 7 or more (otherwise, invalid)
 	if (NF >=7) {

 		field_count["byr"] = 0;
 		field_count["iyr"] = 0;
 		field_count["eyr"] = 0;
 		field_count["hgt"] = 0;
 		field_count["hcl"] = 0;
 		field_count["ecl"] = 0;
 		field_count["pid"] = 0;
 		field_count["cid"] = 0;

 		# For part two, check validity of fields as they're counted.
 		for (i=1; i<=NF; i++) {
 			split($i, v, ":");
 			field_count[v[1]]++;
 			#print $i
 			if (v[1] == "byr") {
 				year = v[2] + 0;
 				if (year < 1920 || year >2002) {
 					is_fields_invalid = 1;
 					print "Bad birth year", year;
 				}
 			}
 			if (v[1] == "iyr") {
 				year = v[2] + 0;
 				if (year < 2010 || year >2020) {
 					is_fields_invalid = 1;
 					print "Bad issue year", year;
 				}
 			}
 			if (v[1] == "eyr") {
 				year = v[2] + 0;
 				if (year < 2020 || year >2030) {
 					is_fields_invalid = 1;
 					print "Bad expiry year", year;
 				}
 			}
 			if (v[1] == "hgt") {
 				if (match(v[2], /^[0-9]+(cm|in)$/) == 0) {
 					is_fields_invalid = 1;
 					print "Bad height", v[2];
 				} else {
	 				unit = substr(v[2], length(v[2]) - 2 + 1, 2);
	 				value = substr(v[2], 1, length(v[2]) - 2) + 0;
	 				if (((unit == "cm") && (value < 150 || value >193)) ||
	 				 	((unit == "in") && (value < 59 || value >76))) {
		 					is_invalid = 1;
		 					print "Bad height", value, unit;
		 			}
		 		}
 			}
 			if (v[1] == "hcl") {
 				if (match(v[2], /^#[0-9a-f]{6}$/) == 0) {
 					is_fields_invalid = 1;
 					print "Bad hair color", v[2];
 				}
 			}
 			if (v[1] == "ecl") {
 				if (match(v[2], /^(amb|blu|brn|gry|grn|hzl|oth)$/) == 0) {
 					is_fields_invalid = 1;
 					print "Bad eye color", v[2];
 				}
 			}
 			if (v[1] == "pid") {
 				if (match(v[2], /^[0-9]{9}$/) == 0) {
 					is_fields_invalid = 1;
 					print "Bad PID", v[2];
 				}
 			}
		}

 		# Check field presences.
 		for (f in field_count) {
 			if (field_count[f] > 1) {
 				is_fields_missing = 1;
 				print "Repeated field"
 				break;
 			}
 			# Invalid if any field other than cid is missing.
 			if (field_count[f] == 0) {
 				if (f != "cid") {
 					is_fields_missing = 1;
 					break;
 				}
 			}
 		}

 		if (is_fields_missing == 0 ) {
 			part_one_valid_count++;
 		}
 		if (is_fields_missing == 0 && is_fields_invalid == 0) {
 			part_two_valid_count++;
 		}
 		
 	}
}

END {
    print "Part one:", part_one_valid_count, "passorts are valid"
    print "Part two:", part_two_valid_count, "passorts are valid"
}

#byr (Birth Year)
#iyr (Issue Year)
#eyr (Expiration Year)
#hgt (Height)
#hcl (Hair Color)
#ecl (Eye Color)
#pid (Passport ID)
#cid (Country ID)