#!/bin/perl

my ($file) = @ARGV;


print "Reading $file\n";


open(my $in, "<", $file) or die "Cannot open $file: $!";

my $num_valid = 0, $num_invalid = 0;
my $num_valid_second = 0, $num_invalid_second = 0;
my $total = 0;
while (<$in>) {
	
	if ( /^(\d+)-(\d+)\s(\w):\s(.+)$/) {

     	#my $min = $1; $max = $2; $char = $3; $password = $4;
		my $first = $1; $second = $2; $char = $3; $password = $4;
      	
      	# How many times does $char appear in $password?
      	my $count = () = $password =~ /\Q$char/g;

      	# First case, occurrence of $char less than $first, no more than $second.
      	if ($count >= $first and $count <= $second) {
      		# Good
      		$num_valid++;
      	} else {
      		#Bad
      		$num_invalid++;
      	}

      	# Second case, exactly one position must be the char
      	if ((substr($password, $first - 1, 1) eq $char) xor 
      	    (substr($password, $second - 1, 1) eq $char)) {
      	    $num_valid_second++;
      	} else {
      		$num_invalid_second++;
      	}

	}

}

print "First case:\n";
print "$num_invalid passwords are invalid.\n";
print "$num_valid password are valid\n";
print "Second case\n";
print "$num_invalid_second passwords are invalid.\n";
print "$num_valid_second password are valid\n";

